import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/network/config/base_response.dart';

class ProfileBloc {
  StreamController<BaseResponse<String>> fullNameController;
  StreamController<BaseResponse<String>> userNameController;
  StreamController<BaseResponse<String>> emailController;
  StreamController<BaseResponse<String>> avatarController;
  StreamController<BaseResponse<String>> bioController;
  StreamController<BaseResponse<String>> websiteController;

  ProfileBloc() {
    fullNameController = StreamController();
    userNameController = StreamController();
    emailController = StreamController();
    avatarController = StreamController();
    bioController = StreamController();
    websiteController = StreamController();
  }

  dispose() {
    fullNameController.close();
    userNameController.close();
    emailController.close();
    avatarController.close();
    bioController.close();
    websiteController.close();
  }

  getUserData() async {
    var user = await UserDAO().get();

    fullNameController.add(BaseResponse.completed(data: user.data.fullname));
    userNameController.add(BaseResponse.completed(data: user.data.username));
    emailController.add(BaseResponse.completed(data: user.data.email));
    avatarController.add(BaseResponse.completed(data: user.data.avatar));
    bioController.add(BaseResponse.completed(data: user.data.bio));
    websiteController.add(BaseResponse.completed(data: user.data.website));
  }
}
