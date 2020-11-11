import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/follower_network.dart';

class FollowerBloc {
  StreamController<BaseResponse<List<User>>> followerController;
  List<User> listFollowers = List<User>();
  String userEmail;
  String _id;

  FollowerBloc(String id) {
    _id = id;
    followerController = StreamController();
  }

  dispose() {
    followerController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetFollowers() async {
    followerController.add(BaseResponse.loading());
    try {
      var response = await FollowerNetwork().doRequestGetFollowers();
      response.forEach((element) {
        if (element.following.toString().contains(_id)) {
          listFollowers.add(element);
        }
      });
      followerController.add(BaseResponse.completed(data: listFollowers));
    } catch (e) {
      followerController.add(BaseResponse.error(e.toString()));
    }
  }
}
