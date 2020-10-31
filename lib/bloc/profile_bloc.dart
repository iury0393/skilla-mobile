import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';

class ProfileBloc {
  StreamController<BaseResponse<String>> fullNameController;
  StreamController<BaseResponse<String>> userNameController;
  StreamController<BaseResponse<String>> emailController;
  StreamController<BaseResponse<String>> avatarController;
  StreamController<BaseResponse<String>> bioController;
  StreamController<BaseResponse<String>> websiteController;
  StreamController<BaseResponse<int>> postCountController;
  StreamController<BaseResponse<int>> followerCountController;
  StreamController<BaseResponse<int>> followingCountController;
  String id;
  String userEmail;

  ProfileBloc() {
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
    var user = await UserDAO().get();
    id = user.data.id;
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
}
