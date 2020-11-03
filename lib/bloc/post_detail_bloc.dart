import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/post_detail_network.dart';

class PostDetailBloc {
  StreamController<BaseResponse<List<Comment>>> commentController;
  StreamController<BaseResponse<void>> addCommentController;
  TextEditingController textCommentController;
  List<Comment> commentsList = List<Comment>();

  PostDetailBloc() {
    commentController = StreamController();
    addCommentController = StreamController();
    textCommentController = TextEditingController();
  }

  dispose() {
    commentController.close();
    addCommentController.close();
    textCommentController.dispose();
  }

  doRequestGetComments(String userId) async {
    commentController.add(BaseResponse.loading());
    try {
      var response = await PostDetailNetwork().doRequestgetFeed();
      response.forEach((feed) {
        if (feed.user.id == userId) {
          feed.comments.forEach((comments) {
            commentsList.add(comments);
          });
        }
      });
      commentController.add(BaseResponse.completed(data: commentsList));
    } catch (e) {
      commentController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestAddComment(String postId) async {
    addCommentController.add(BaseResponse.loading());
    try {
      var body = Comment(
        text: textCommentController.text,
      ).toJson();
      await PostDetailNetwork().doRequestAddComment(postId, body);
      addCommentController.add(BaseResponse.completed());
    } catch (e) {
      addCommentController.add(BaseResponse.error(e.toString()));
    }
  }
}
