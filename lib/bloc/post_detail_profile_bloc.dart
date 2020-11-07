import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/comment_data.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/post_detail_network.dart';

class PostDetailBloc {
  StreamController<BaseResponse<List<Comment>>> commentController;
  StreamController<BaseResponse<Comment>> addCommentController;
  StreamController<BaseResponse<void>> deleteCommentController;
  TextEditingController textCommentController;
  List<Comment> commentsList = List<Comment>();

  PostDetailBloc(List<Comment> comments) {
    commentsList = comments;
    commentController = StreamController();
    addCommentController = StreamController();
    deleteCommentController = StreamController();
    textCommentController = TextEditingController();
  }

  dispose() {
    commentController.close();
    addCommentController.close();
    deleteCommentController.close();
    textCommentController.dispose();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doGetComment() {
    commentController.add(BaseResponse.loading());
    try {
      commentController.add(BaseResponse.completed(data: commentsList));
    } catch (e) {
      commentController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestAddComment(String postId) async {
    addCommentController.add(BaseResponse.loading());
    try {
      var body = CommentData(
        text: textCommentController.text,
      ).toJson();
      var response =
          await PostDetailNetwork().doRequestAddComment(postId, body);
      commentsList.add(response);
      commentController.add(BaseResponse.completed(data: commentsList));
      addCommentController.add(BaseResponse.completed(data: response));
    } catch (e) {
      addCommentController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestDeleteComment(String commentId, String postId) async {
    deleteCommentController.add(BaseResponse.loading());
    try {
      await PostDetailNetwork().doRequestDeteleComment(commentId, postId);
      commentsList.removeWhere((element) => element.id == commentId);
      commentController.add(BaseResponse.completed(data: commentsList));
      deleteCommentController.add(BaseResponse.completed());
    } catch (e) {
      deleteCommentController.add(BaseResponse.error(e.toString()));
    }
  }
}
