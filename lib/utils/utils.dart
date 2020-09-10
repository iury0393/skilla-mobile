import 'package:flutter/material.dart';

class Utils {
  static String appLanguage;

  static EdgeInsets getPaddingDefault({double left, double top, double right}) {
    return EdgeInsets.fromLTRB(left != null ? left : 20.0,
        top != null ? top : 10.0, right != null ? right : 20.0, 10.0);
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value.trim());
  }

  static bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d][\w~@#$%^&*+=`|{}:;!.?\"()\[\]-]{7,}$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value.trim());
  }
}
