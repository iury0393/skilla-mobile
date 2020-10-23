import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/model/auth_data.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/sign_in_service.dart';
import 'package:skilla/network/user_service.dart';
import 'package:skilla/utils/user_auth.dart';
import 'package:skilla/utils/utils.dart';

class SignInBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;

  StreamController<BaseResponse<dynamic>> loginStreamController;
  StreamController<bool> obfuscatePasswordStreamController;

  String email;
  String password;

  GlobalKey<FormState> formKey;

  bool isEmailErrorDisplayed = false;
  bool isPasswordErrorDisplayed = false;

  SignInBloc() {
    formKey = GlobalKey<FormState>();
    textPasswordController = TextEditingController();
    textEmailController = TextEditingController();
    loginStreamController = StreamController();
    obfuscatePasswordStreamController = StreamController();
  }

  dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();
    loginStreamController.close();
    obfuscatePasswordStreamController.close();
  }

  doRequestLogin() async {
    loginStreamController.add(BaseResponse.loading());
    try {
      var body = AuthData(
              email: textEmailController.text.toLowerCase(),
              password: textPasswordController.text)
          .toJson();
      var response = await SignInService().doRequestLogin(body);
      await _saveAuthInDB(response);
      await _doRequestGetUserData();
    } catch (e) {
      loginStreamController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveAuthInDB(Auth auth) async {
    try {
      UserAuth.auth = auth;
      await AuthDAO().save(auth);
    } catch (e) {
      await Utils.cleanDataBase();
      loginStreamController.add(BaseResponse.error(e.toString()));
    }
  }

  _doRequestGetUserData() async {
    try {
      var response = await UserService().doRequestGetUser();
      response.email = textEmailController.text.toLowerCase();
      loginStreamController.add(BaseResponse.completed());
    } catch (e) {
      loginStreamController.add(BaseResponse.error(e.toString()));
    }
  }
}
