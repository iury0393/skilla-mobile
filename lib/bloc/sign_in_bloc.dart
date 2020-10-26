import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/model/auth_data.dart';
import 'package:skilla/model/user.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/sign_in_network.dart';
import 'package:skilla/network/user_network.dart';
import 'package:skilla/utils/user_auth.dart';
import 'package:skilla/utils/utils.dart';

class SignInBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;

  StreamController<BaseResponse<dynamic>> loginController;
  StreamController<bool> obfuscatePasswordController;

  String email;
  String password;

  GlobalKey<FormState> formKey;

  bool isEmailErrorDisplayed = false;
  bool isPasswordErrorDisplayed = false;

  SignInBloc() {
    formKey = GlobalKey<FormState>();
    textPasswordController = TextEditingController();
    textEmailController = TextEditingController();
    loginController = StreamController();
    obfuscatePasswordController = StreamController();
  }

  dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();
    loginController.close();
    obfuscatePasswordController.close();
  }

  doRequestLogin() async {
    loginController.add(BaseResponse.loading());
    try {
      var body = AuthData(
              email: textEmailController.text.toLowerCase(),
              password: textPasswordController.text)
          .toJson();
      var response = await SignInNetwork().doRequestLogin(body);
      await _saveAuthInDB(response);
      await _doRequestGetUserData();
    } catch (e) {
      loginController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveAuthInDB(Auth auth) async {
    try {
      UserAuth.auth = auth;
      await AuthDAO().save(auth);
    } catch (e) {
      await Utils.cleanDataBase();
      loginController.add(BaseResponse.error(e.toString()));
    }
  }

  _doRequestGetUserData() async {
    try {
      var response = await UserNetwork().doRequestGetUser();
      response.email = textEmailController.text.toLowerCase();
      await _saveUserInDB(response);
      loginController.add(BaseResponse.completed());
    } catch (e) {
      loginController.add(BaseResponse.error(e.toString()));
    }
  }

  _saveUserInDB(User user) async {
    try {
      await UserDAO().save(user);
    } catch (e) {
      await Utils.cleanDataBase();
      loginController.add(BaseResponse.error(e.toString()));
    }
  }
}
