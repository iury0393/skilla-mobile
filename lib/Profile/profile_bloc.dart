import 'dart:async';

import 'package:skilla/Intro/user_network.dart';
import 'package:skilla/Profile/profile_network.dart';
import 'package:skilla/utils/dao/user_dao.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/post_detail.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/utils.dart';

class ProfileBloc {
  UserNetwork _userService = UserNetwork();
  bool isChecked = false;
  BaseResponse<User> user;
  StreamController<BaseResponse<User>> profileController;
  StreamController<BaseResponse<void>> followController;
  StreamController<BaseResponse<void>> unFollowController;
  StreamController<BaseResponse<Post>> postController;
  StreamController<BaseResponse<List<PostDetail>>> postsController;
  StreamController<BaseResponse<String>> fullNameController;
  StreamController<BaseResponse<String>> userNameController;
  StreamController<BaseResponse<String>> emailController;
  StreamController<BaseResponse<String>> avatarController;
  StreamController<BaseResponse<String>> bioController;
  StreamController<BaseResponse<String>> websiteController;
  StreamController<BaseResponse<int>> postCountController;
  StreamController<BaseResponse<int>> followerCountController;
  StreamController<BaseResponse<int>> followingCountController;
  List<PostDetail> listPostsUser = List<PostDetail>();

  ProfileBloc() {
    profileController = StreamController();
    followController = StreamController();
    unFollowController = StreamController();
    postController = StreamController();
    postsController = StreamController.broadcast();
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
    profileController.close();
    followController.close();
    unFollowController.close();
    postController.close();
    postsController.close();
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
    profileController.add(BaseResponse.loading());
    try {
      user = await UserDAO().get();
      profileController.add(BaseResponse.completed(data: user.data));
    } catch (e) {
      profileController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestGetPosts(String id) async {
    postsController.add(BaseResponse.loading());
    try {
      var response = await ProfileNetwork().doRequestGetPosts();
      response.forEach((post) {
        if (post.user == id) {
          listPostsUser.add(post);
        }
      });
      postsController.add(BaseResponse.completed(data: listPostsUser));
    } catch (e) {
      postsController.add(BaseResponse.error(e.toString()));
    }
  }

  Future<Post> doRequestGetPost(String postId) async {
    return await ProfileNetwork().doRequestGetPost(postId);
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

  doRequestUnFollow(String id) async {
    unFollowController.add(BaseResponse.loading());
    try {
      await ProfileNetwork().doRequestUnFollow(id);
      _doRequestGetUserLoggedDataUn();
    } catch (e) {
      unFollowController.add(BaseResponse.error(e.toString()));
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

  _doRequestGetUserLoggedDataUn() async {
    try {
      var userResponse = await _userService.doRequestGetUser();
      _updateUserInDBUn(userResponse);
    } catch (e) {
      unFollowController.add(BaseResponse.error(e.toString()));
    }
  }

  _updateUserInDBUn(User userData) async {
    try {
      User user = User().generateDataFromUser(userData);
      print(user);
      _saveUserInDBUn(user);
    } catch (e) {
      unFollowController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveUserInDBUn(User user) async {
    try {
      await Utils.cleanDataBaseUser();
      await UserDAO().save(user);
      unFollowController.add(BaseResponse.completed());
    } catch (e) {
      unFollowController.add(BaseResponse.error(e.toString()));
    }
  }

  Future<bool> isFollowing(String userId) async {
    var response = await ProfileNetwork().doRequestGetUsers();
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
