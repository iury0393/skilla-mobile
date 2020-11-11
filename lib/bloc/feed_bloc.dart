import 'dart:async';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/post.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/feed_network.dart';
import 'package:skilla/network/profile_network.dart';
import 'package:skilla/utils/utils.dart';

class FeedBloc {
  StreamController<BaseResponse<List<Post>>> feedController;
  StreamController<BaseResponse<void>> deletePostController;
  StreamController<BaseResponse<User>> userController;
  RefreshController refreshController;
  String userEmail;
  User user;
  bool needClearList = true;

  FeedBloc() {
    userController = StreamController();
    deletePostController = StreamController();
    feedController = StreamController();
    refreshController = RefreshController(initialRefresh: false);
  }

  dispose() {
    userController.close();
    deletePostController.close();
    feedController.close();
    refreshController.dispose();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  Future<Post> doRequestGetPost(String postId) async {
    return await ProfileNetwork().doRequestGetPost(postId);
  }

  doRequestGetFeed(bool withLoading) async {
    if (withLoading) {
      feedController.add(BaseResponse.loading());
    }

    try {
      var response = await FeedNetwork().doRequestGetFeed();
      if (response != null) {
        if (needClearList) {
          needClearList = false;
          Utils.listOfPosts.clear();
        }
        Utils.listOfPosts = response;
      }

      feedController.add(BaseResponse.completed(data: Utils.listOfPosts));
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

  doRequestDeletePost(String postId) async {
    deletePostController.add(BaseResponse.loading());
    try {
      await FeedNetwork().doRequestDeletePost(postId);
      deletePostController.add(BaseResponse.completed());
    } catch (e) {
      deletePostController.add(BaseResponse.error(e.toString()));
    }
  }

  Future<Null> refreshFeed() async {
    Utils.listOfPosts.clear();
    await doRequestGetFeed(false);
  }
}
