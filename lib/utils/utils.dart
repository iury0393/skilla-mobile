import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/dao/user_dao.dart';

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

  static Future<String> getUUID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return '$version.$buildNumber';
  }

  static Future cleanDataBase() async {
    await AuthDAO().cleanTable();
    await UserDAO().cleanTable();
  }

  static int whenRefreshToken(int expiration) {
    DateTime now = DateTime.now();
    Duration timeNow =
        new Duration(hours: now.hour, minutes: now.minute, seconds: now.second);
    return (timeNow.inSeconds + expiration) - 300;
  }
}
