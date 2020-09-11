import 'dart:async';

import 'package:flutter/material.dart';

class SignUpBloc {
  TextEditingController textEmailController;
  TextEditingController textPasswordController;
  TextEditingController textNameController;
  TextEditingController textUsernameController;

  StreamController<bool> obfuscatePasswordStreamController;

  GlobalKey<FormState> formKey;

  bool isEmailErrorDisplayed = false;
  bool isNameErrorDisplayed = false;
  bool isUsernameErrorDisplayed = false;
  bool isPasswordErrorDisplayed = false;

  SignUpBloc() {
    formKey = GlobalKey<FormState>();
    textPasswordController = TextEditingController();
    textEmailController = TextEditingController();
    textNameController = TextEditingController();
    textUsernameController = TextEditingController();
    obfuscatePasswordStreamController = StreamController();
  }

  dispose() {
    textEmailController.dispose();
    textPasswordController.dispose();
    obfuscatePasswordStreamController.close();
  }
}
