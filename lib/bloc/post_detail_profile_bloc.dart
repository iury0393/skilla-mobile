import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/post_detail_network.dart';
import 'package:skilla/network/post_detail_profile_network.dart';

class PostDetailProfileBloc {
  PostDetailNetwork postDetailNetwork = PostDetailNetwork();
  StreamController<BaseResponse<Post>> postController;
  StreamController<BaseResponse<List<Comment>>> commentController;
  StreamController<BaseResponse<void>> addCommentController;
  StreamController<BaseResponse<void>> deleteCommentController;
  TextEditingController textCommentController;
  List<Comment> commentsList = List<Comment>();

  PostDetailProfileBloc() {
    postController = StreamController();
    commentController = StreamController();
    addCommentController = StreamController();
    deleteCommentController = StreamController();
    textCommentController = TextEditingController();
  }

  dispose() {
    postController.close();
    commentController.close();
    addCommentController.close();
    deleteCommentController.close();
    textCommentController.dispose();
  }

  Future doRequestGetPost(String postId) async {
    postController.add(BaseResponse.loading());
    try {
      var response = await PostDetailProfileNetwork().doRequestGetPost(postId);
      postController.add(BaseResponse.completed(data: response));
    } catch (e) {
      postController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestGetComments(Post post) async {
    commentController.add(BaseResponse.loading());
    try {
      var response = await postDetailNetwork.doRequestgetFeed();
      response.forEach((feed) {
        if (feed.user.id == post.user.id) {
          if (feed.id == post.id) {
            feed.comments.forEach((comments) {
              if (commentsList.contains(comments)) {
                commentsList.remove(comments);
              } else {
                commentsList.add(comments);
              }
            });
          }
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
      var response = await postDetailNetwork.doRequestAddComment(postId, body);
      commentsList.add(response);
      addCommentController.add(BaseResponse.completed(data: commentsList));
    } catch (e) {
      addCommentController.add(BaseResponse.error(e.toString()));
    }
  }

  doRequestDeleteComment(String commentId, String postId) async {
    deleteCommentController.add(BaseResponse.loading());
    try {
      await postDetailNetwork.doRequestDeteleComment(commentId, postId);
      commentsList.removeWhere((element) => element.id == commentId);
      commentController.add(BaseResponse.completed(data: commentsList));
      deleteCommentController.add(BaseResponse.completed());
    } catch (e) {
      deleteCommentController.add(BaseResponse.error(e.toString()));
    }
  }
}
