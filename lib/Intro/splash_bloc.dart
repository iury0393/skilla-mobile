import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/utils/dao/auth_dao.dart';
import 'package:skilla/utils/model/auth.dart';
import 'package:skilla/utils/network/base_response.dart';
import 'package:skilla/utils/user_auth.dart';

class SplashBloc {
  StreamController<BaseResponse<Auth>> authStreamController;

  AuthDAO _authDAO = AuthDAO();

  SplashBloc() {
    authStreamController = StreamController();
  }

  void dispose() {
    authStreamController.close();
  }

  getDataFromDB() async {
    authStreamController.add(BaseResponse.loading());
    try {
      var auth = await AuthDAO().get();
      if (auth.data.token != null) {
        await _checkIfNeedRefreshToken(auth.data);
      } else {
        authStreamController.add(BaseResponse.completed(data: null));
      }
    } catch (e) {
      authStreamController.add(BaseResponse.error(e.toString()));
    }
  }

  _checkIfNeedRefreshToken(Auth auth) async {
    print("TOKEN: $auth");

    await _doRequestRefreshToken(currentAccessToken: auth);
  }

  _doRequestRefreshToken({@required Auth currentAccessToken}) async {
    try {
      await _updateAuthDB(currentAccessToken);
    } catch (e) {
      authStreamController.add(BaseResponse.error(e.toString()));
    }
  }

  _updateAuthDB(Auth auth) async {
    try {
      UserAuth.auth = auth;
      await _authDAO.update(auth);
      authStreamController.add(BaseResponse.completed(data: auth));
    } catch (e) {
      authStreamController.add(BaseResponse.error(e.toString()));
    }
  }
}
