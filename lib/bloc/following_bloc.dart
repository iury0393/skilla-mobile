import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/following_network.dart';

class FollowingBloc {
  StreamController<BaseResponse<List<User>>> followingController;
  List<User> listFollowings = List<User>();
  String userEmail;

  FollowingBloc() {
    followingController = StreamController();
  }

  dispose() {
    followingController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetUsers() async {
    followingController.add(BaseResponse.loading());
    try {
      var response = await FollowingNetwork().doRequestgetUsers();
      var user = await getUser();
      response.forEach((element) {
        if (element.followers.toString().contains(user.data.id)) {
          listFollowings.add(element);
        }
      });
      followingController.add(BaseResponse.completed(data: listFollowings));
    } catch (e) {
      followingController.add(BaseResponse.error(e.toString()));
    }
  }
}
