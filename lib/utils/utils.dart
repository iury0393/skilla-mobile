import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info/package_info.dart';
import 'package:skilla/dao/auth_dao.dart';
import 'package:skilla/dao/user_dao.dart';
import 'package:skilla/model/comment.dart';
import 'package:skilla/model/user.dart';

class Utils {
  static String appLanguage;
  static List<Comment> commentsList = [];
  static List<User> listOfUsers = [];

  static double _height = 120.0;
  static double _width = 120.0;
  static double _heightOther = 40.0;
  static double _widthOther = 40.0;

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

  static int whenRefreshToken(int expiration) {
    DateTime now = DateTime.now();
    Duration timeNow =
        new Duration(hours: now.hour, minutes: now.minute, seconds: now.second);
    return (timeNow.inSeconds + expiration) - 300;
  }

  static Future cleanDataBase() async {
    await AuthDAO().cleanTable();
    await UserDAO().cleanTable();
  }

  static Future cleanDataBaseUser() async {
    await UserDAO().cleanTable();
  }

  static Widget loadImage(String url, BuildContext context, bool isOther) {
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        placeholder: (context, url) => _buildPlaceholder(
          context,
          isOther ? _heightOther : _height,
          isOther ? _widthOther : _width,
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(
          context,
          isOther ? _heightOther : _height,
          isOther ? _widthOther : _width,
        ),
        imageUrl: url,
        height: isOther ? _heightOther : _height,
        width: isOther ? _widthOther : _width,
        fit: BoxFit.cover,
        imageBuilder: (context, imgProvider) {
          return _buildImageFromURL(imgProvider, isOther);
        },
      );
    }

    return _buildPlaceholder(
      context,
      isOther ? _heightOther : _height,
      isOther ? _widthOther : _width,
    );
  }

  static ClipRRect _buildPlaceholder(
      BuildContext context, double height, double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static ClipRRect _buildImageFromURL(ImageProvider imgProvider, bool isOther) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        height: isOther ? _heightOther : _height,
        width: isOther ? _widthOther : _width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imgProvider,
          ),
        ),
      ),
    );
  }

  static String convertToDisplayTimeDetail(
      String timeStamp, BuildContext context) {
    try {
      Jiffy.locale(Utils.appLanguage);

      var jiffy = Jiffy(timeStamp).format("dd [de] ");
      var jiffyMonth = Jiffy(timeStamp).format("MMMM");

      return "$jiffy${jiffyMonth[0].toUpperCase()}${jiffyMonth.substring(1)}";
    } catch (e) {
      return timeStamp;
    }
  }
}
