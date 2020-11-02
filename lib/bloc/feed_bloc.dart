import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/feed_network.dart';

class FeedBloc {
  StreamController<BaseResponse<List<Post>>> feedController;
  StreamController<BaseResponse<User>> userController;
  String userEmail;
  User user;

  FeedBloc() {
    userController = StreamController();
    feedController = StreamController();
  }

  dispose() {
    userController.close();
    feedController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetFeed() async {
    feedController.add(BaseResponse.loading());
    try {
      var response = await FeedNetwork().doRequestgetFeed();
      feedController.add(BaseResponse.completed(data: response));
    } catch (e) {
      feedController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestGetUser(String username) async {
    userController.add(BaseResponse.loading());
    try {
      var response = await FeedNetwork().doRequestGetUser(username);
      userController.add(BaseResponse.completed(data: response));
    } catch (e) {
      userController.add(BaseResponse.error(e.toString()));
    }
  }
}
