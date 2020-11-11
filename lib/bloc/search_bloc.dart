import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/search_network.dart';
import 'package:skilla/utils/utils.dart';

class SearchBloc {
  StreamController<BaseResponse<List<User>>> recommendedController;
  TextEditingController searchUserController;
  String userEmail = '';

  SearchBloc() {
    searchUserController = TextEditingController();
    recommendedController = StreamController();
  }

  dispose() {
    searchUserController.dispose();
    recommendedController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetUsers() async {
    recommendedController.add(BaseResponse.loading());
    try {
      var response = await SearchNetwork().doRequestGetUsers();
      Utils.listOfUsers = response;
      recommendedController
          .add(BaseResponse.completed(data: Utils.listOfUsers));
    } catch (e) {
      recommendedController.add(BaseResponse.error(e.toString()));
    }
  }
}
