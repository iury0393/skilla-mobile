import 'dart:async';

import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/search_network.dart';
import 'package:skilla/utils/utils.dart';

class SearchBloc {
  StreamController<BaseResponse<List<User>>> recommendedController;
  String userEmail = '';

  SearchBloc() {
    recommendedController = StreamController();
  }

  dispose() {
    recommendedController.close();
  }

  Future<BaseResponse<User>> getUser() async {
    return await UserDAO().get();
  }

  doRequestGetUsers() async {
    recommendedController.add(BaseResponse.loading());
    try {
      var response = await SearchNetwork().doRequestgetUsers();
      Utils.listOfUsers = response;
      recommendedController
          .add(BaseResponse.completed(data: Utils.listOfUsers));
    } catch (e) {
      recommendedController.add(BaseResponse.error(e.toString()));
    }
  }
}
