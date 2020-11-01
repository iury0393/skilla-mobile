import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/likes_network.dart';

class LikesBloc {
  StreamController<BaseResponse<List<User>>> likesController;
  List<User> listUsers = List<User>();
  String userEmail;

  LikesBloc() {
    likesController = StreamController();
  }

  dispose() {
    likesController.close();
  }

  doRequestGetLikes() async {
    likesController.add(BaseResponse.loading());
    try {
      var responseFeed = await LikesNetwork().doRequestgetFeed();
      var responseUser = await LikesNetwork().doRequestgetUsers();
      print(responseUser);
      responseFeed.forEach((feed) {
        responseUser.forEach((user) {
          if (feed.likes.toString().contains(user.id)) {
            print("object");
          }
        });
      });
      likesController.add(BaseResponse.completed(data: listUsers));
    } catch (e) {
      likesController.add(BaseResponse.error(e.toString()));
    }
  }
}
