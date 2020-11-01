import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/feed_network.dart';

class FeedBloc {
  StreamController<BaseResponse<List<Post>>> feedController;
  String userEmail;
  User user;

  FeedBloc() {
    feedController = StreamController();
  }

  dispose() {
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
}
