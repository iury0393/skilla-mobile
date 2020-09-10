import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagerDialogs {
  static void showErrorDialog(
      BuildContext context, String title, String message) {
    if (Platform.isAndroid) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    }
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Center(
            child: Platform.isIOS ? _iosLoading() : _androidLoading(),
          ),
        ),
      ),
    );
  }

  static _iosLoading() {
    return CupertinoActivityIndicator(
      animating: true, //animating,
    );
  }

  static _androidLoading() {
    return Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),
    );
  }
}
