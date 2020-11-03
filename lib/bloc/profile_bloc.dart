import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/profile_network.dart';
import 'package:skilla/network/user_network.dart';
import 'package:skilla/utils/utils.dart';

class ProfileBloc {
  UserNetwork _userService = UserNetwork();
  bool isChecked = false;
  BaseResponse<User> user;
  StreamController<BaseResponse<void>> followController;
  StreamController<BaseResponse<List<Post>>> postController;
  StreamController<BaseResponse<String>> fullNameController;
  StreamController<BaseResponse<String>> userNameController;
  StreamController<BaseResponse<String>> emailController;
  StreamController<BaseResponse<String>> avatarController;
  StreamController<BaseResponse<String>> bioController;
  StreamController<BaseResponse<String>> websiteController;
  StreamController<BaseResponse<int>> postCountController;
  StreamController<BaseResponse<int>> followerCountController;
  StreamController<BaseResponse<int>> followingCountController;
  List<Post> listPostsUser = List<Post>();

  ProfileBloc() {
    followController = StreamController();
    postController = StreamController();
    fullNameController = StreamController();
    userNameController = StreamController();
    emailController = StreamController();
    avatarController = StreamController();
    bioController = StreamController();
    websiteController = StreamController();
    postCountController = StreamController();
    followerCountController = StreamController();
    followingCountController = StreamController();
  }

  dispose() {
    followController.close();
    postController.close();
    fullNameController.close();
    userNameController.close();
    emailController.close();
    avatarController.close();
    bioController.close();
    websiteController.close();
    postCountController.close();
    followerCountController.close();
    followingCountController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  getUserData() async {
    user = await UserDAO().get();
    fullNameController.add(BaseResponse.completed(data: user.data.fullname));
    userNameController.add(BaseResponse.completed(data: user.data.username));
    emailController.add(BaseResponse.completed(data: user.data.email));
    avatarController.add(BaseResponse.completed(data: user.data.avatar));
    bioController.add(BaseResponse.completed(data: user.data.bio));
    websiteController.add(BaseResponse.completed(data: user.data.website));
    postCountController.add(BaseResponse.completed(data: user.data.postCount));
    followerCountController
        .add(BaseResponse.completed(data: user.data.followersCount));
    followingCountController
        .add(BaseResponse.completed(data: user.data.followingCount));
  }

  doRequestGetPosts(String id) async {
    postController.add(BaseResponse.loading());
    try {
      var response = await ProfileNetwork().doRequestGetPosts();
      response.forEach((post) {
        if (post.user.id == id) {
          listPostsUser.add(post);
        }
      });
      postController.add(BaseResponse.completed(data: listPostsUser));
    } catch (e) {
      postController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestFollow(String id) async {
    followController.add(BaseResponse.loading());
    try {
      await ProfileNetwork().doRequestFollow(id);
      _doRequestGetUserLoggedData();
    } catch (e) {
      followController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestUnfollow(String id) async {
    followController.add(BaseResponse.loading());
    try {
      await ProfileNetwork().doRequestUnfollow(id);
      _doRequestGetUserLoggedData();
    } catch (e) {
      followController.add(BaseResponse.error(e.toString()));
    }
  }

  _doRequestGetUserLoggedData() async {
    try {
      var userResponse = await _userService.doRequestGetUser();
      _updateUserInDB(userResponse);
    } catch (e) {
      followController.add(BaseResponse.error(e.toString()));
    }
  }

  _updateUserInDB(User userData) async {
    try {
      User user = User().generateDataFromUser(userData);
      print(user);
      _saveUserInDB(user);
    } catch (e) {
      followController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveUserInDB(User user) async {
    try {
      await Utils.cleanDataBaseUser();
      await UserDAO().save(user);
      followController.add(BaseResponse.completed());
    } catch (e) {
      followController.add(BaseResponse.error(e.toString()));
    }
  }

  Future<bool> isFollowing(String userId) async {
    var response = await ProfileNetwork().doRequestgetUsers();
    var userSelf = await UserDAO().get();
    response.forEach((user) {
      if (user.id == userId) {
        if (user.followers.toString().contains(userSelf.data.id)) {
          isChecked = true;
        }
      }
    });
    return isChecked;
  }
}
