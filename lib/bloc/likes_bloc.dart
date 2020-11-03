import 'dart:async';

import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/likes_network.dart';

class LikesBloc {
  StreamController<BaseResponse<List<User>>> likesController;
  StreamController<BaseResponse<void>> toggleLikesController;
  List<User> listUsers = List<User>();
  String userEmail;
  Post _userPost;

  LikesBloc(User user, Post post) {
    _userPost = post;
    likesController = StreamController();
    toggleLikesController = StreamController();
  }

  dispose() {
    likesController.close();
    toggleLikesController.close();
  }

  doRequestGetLikes() async {
    likesController.add(BaseResponse.loading());
    try {
      var responseFeed = await LikesNetwork().doRequestgetFeed();
      var responseUser = await LikesNetwork().doRequestgetUsers();
      responseFeed.forEach((feed) {
        if (feed.caption == _userPost.caption) {
          responseUser.forEach((user) {
            if (feed.likes.toString().contains(user.id)) {
              listUsers.add(user);
            }
          });
        }
      });
      likesController.add(BaseResponse.completed(data: listUsers));
    } catch (e) {
      likesController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequesttoggleLike(String postId) async {
    toggleLikesController.add(BaseResponse.loading());
    try {
      await LikesNetwork().doRequestToggleLike(postId);
      toggleLikesController.add(BaseResponse.completed());
    } catch (e) {
      toggleLikesController.add(BaseResponse.error(e.toString()));
    }
  }
}
