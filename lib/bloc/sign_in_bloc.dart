import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/network/sign_in_service.dart';
import 'package:skilla/network/user_service.dart';

class SignInBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;

  StreamController<BaseResponse<Auth>> loginStreamController;
  StreamController<bool> obfuscatePasswordStreamController;

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
      var body = Auth(
              email: textEmailController.text.toLowerCase(),
              password: textPasswordController.text)
          .toJson();
      var response = await SignInService().doRequestLogin(body);

      await _doRequestGetUserData(response);
    } catch (e) {
      loginStreamController.add(BaseResponse.error(e.toString()));
    }
  }

  _doRequestGetUserData(Auth auth) async {
    try {
      var response = await UserService().doRequestGetUser();
      response.email = textEmailController.text.toLowerCase();
    } catch (e) {
      loginStreamController.add(BaseResponse.error(e.toString()));
    }
  }
}
