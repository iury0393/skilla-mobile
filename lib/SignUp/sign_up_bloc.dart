import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skilla/SignUp/sign_up_network.dart';
import 'package:skilla/utils/model/user.dart';
import 'package:skilla/utils/network/base_response.dart';

class SignUpBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;
  TextEditingController textFullNameController;
  TextEditingController textUserNameController;

  StreamController<bool> obfuscatePasswordController;
  StreamController<BaseResponse<dynamic>> registerController;

  GlobalKey<FormState> formKey;

  bool isEmailErrorDisplayed = false;
  bool isNameErrorDisplayed = false;
  bool isUsernameErrorDisplayed = false;
  bool isPasswordErrorDisplayed = false;

  SignUpBloc() {
    formKey = GlobalKey<FormState>();

    textPasswordController = TextEditingController();
    textEmailController = TextEditingController();
    textFullNameController = TextEditingController();
    textUserNameController = TextEditingController();

    obfuscatePasswordController = StreamController();
    registerController = StreamController();
  }

  dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();
    textFullNameController.dispose();
    textUserNameController.dispose();
    obfuscatePasswordController.close();
    registerController.close();
  }

  doRequestRegister() async {
    registerController.add(BaseResponse.loading());
    try {
      var body = User(
              fullname: textFullNameController.text,
              username: textUserNameController.text,
              email: textEmailController.text.toLowerCase(),
              password: textPasswordController.text)
          .toJson();
      await SignUpNetwork().doRequestRegister(body);
      registerController.add(BaseResponse.completed());
    } catch (e) {
      registerController.add(BaseResponse.error(e.toString()));
    }
  }
}
