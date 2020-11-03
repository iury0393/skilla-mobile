import 'dart:async';

import 'package:skilla/model/comment.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/post_detail_network.dart';

class PostDetailBloc {
  StreamController<BaseResponse<List<Comment>>> commentController;
  List<Comment> commentsList = List<Comment>();

  PostDetailBloc() {
    commentController = StreamController();
  }

  dispose() {
    commentController.close();
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
}
