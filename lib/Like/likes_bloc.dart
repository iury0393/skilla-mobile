import 'dart:async';

import 'package:skilla/Like/likes_network.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';

class LikeBloc {
  StreamController<BaseResponse<List<User>>> likesController;
  StreamController<BaseResponse<void>> toggleLikesController;
  List<User> listUsers = List<User>();
  String userEmail;
  Post _userPost;

  LikeBloc(User user, Post post) {
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
      var responseFeed = await LikesNetwork().doRequestGetFeed();
      var responseUser = await LikesNetwork().doRequestGetUsers();
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

  doRequestToggleLike(String postId) async {
    toggleLikesController.add(BaseResponse.loading());
    try {
      await LikesNetwork().doRequestToggleLike(postId);
      toggleLikesController.add(BaseResponse.completed());
    } catch (e) {
      toggleLikesController.add(BaseResponse.error(e.toString()));
    }
  }
}
