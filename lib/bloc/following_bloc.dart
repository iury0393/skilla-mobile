import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/following_network.dart';

class FollowingBloc {
  StreamController<BaseResponse<List<User>>> followingController;
  List<User> listFollowings = List<User>();
  String userEmail;
  String _id;

  FollowingBloc(String id) {
    _id = id;
    followingController = StreamController();
  }

  dispose() {
    followingController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetFollowings() async {
    followingController.add(BaseResponse.loading());
    try {
      listFollowings = List<User>();

      var response = await FollowingNetwork().doRequestGetFollowing();
      response.forEach((element) {
        if (element.followers.toString().contains(_id)) {
          listFollowings.add(element);
        }
      });
      print(_id);
      listFollowings.forEach((user) {
        print(user.fullname);
      });
      followingController.add(BaseResponse.completed(data: listFollowings));
    } catch (e) {
      followingController.add(BaseResponse.error(e.toString()));
    }
  }
}
