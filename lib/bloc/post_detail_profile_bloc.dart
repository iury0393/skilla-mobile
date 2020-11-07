import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/post_detail_network.dart';
import 'package:skilla/utils/utils.dart';

class PostDetailProfileBloc {
  StreamController<BaseResponse<void>> addCommentController;
  StreamController<BaseResponse<void>> deleteCommentController;
  TextEditingController textCommentController;

  PostDetailProfileBloc() {
    addCommentController = StreamController();
    deleteCommentController = StreamController();
    textCommentController = TextEditingController();
  }

  dispose() {
    addCommentController.close();
    deleteCommentController.close();
    textCommentController.dispose();
  }

  doRequestAddComment(String postId) async {
    addCommentController.add(BaseResponse.loading());
    try {
      var body = Comment(
        text: textCommentController.text,
      ).toJson();
      var response =
          await PostDetailNetwork().doRequestAddComment(postId, body);
      Utils.commentsList.add(response);
      addCommentController
          .add(BaseResponse.completed(data: Utils.commentsList));
    } catch (e) {
      addCommentController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestDeleteComment(String commentId, String postId) async {
    deleteCommentController.add(BaseResponse.loading());
    try {
      await PostDetailNetwork().doRequestDeteleComment(commentId, postId);
      Utils.commentsList.removeWhere((element) => element.id == commentId);
      deleteCommentController.add(BaseResponse.completed());
    } catch (e) {
      deleteCommentController.add(BaseResponse.error(e.toString()));
    }
  }
}
