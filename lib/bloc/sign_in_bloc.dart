import 'dart:async';

import 'package:flutter/material.dart';

class SignInBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;

  StreamController<bool> obfuscatePasswordStreamController;

  GlobalKey<FormState> formKey;

  bool isEmailErrorDisplayed = false;
  bool isPasswordErrorDisplayed = false;

  SignInBloc() {
    formKey = GlobalKey<FormState>();
    textPasswordController = TextEditingController();
    textEmailController = TextEditingController();
    obfuscatePasswordStreamController = StreamController();
  }

  dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();
    obfuscatePasswordStreamController.close();
  }
}
