import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/screens/signFlow/sign_in_screen.dart';
import 'package:skilla/utils/text_styles.dart';
import 'package:skilla/utils/utils.dart';

Future<T> showNativeDialog<T>({BuildContext context, WidgetBuilder builder}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
        barrierDismissible: true, context: context, builder: builder);
  } else {
    return showDialog(
        barrierDismissible: true, context: context, builder: builder);
  }
}

class NativeDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  final BuildContext ctx;

  NativeDialog({Key key, this.title, this.message, this.actions, this.ctx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? iosDialog() : androidDialog();
  }

  CupertinoAlertDialog iosDialog() {
    return CupertinoAlertDialog(
      title: _buildTitle(),
      content: _buildMessage(),
      actions: _buildActions(),
    );
  }

  AlertDialog androidDialog() {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildMessage(),
      actions: _buildActions(),
    );
  }

  Text _buildTitle() {
    return (title != null)
        ? Text(
            title,
            style:
                TextStyles.paragraph(TextSize.small, weight: FontWeight.bold),
          )
        : null;
  }

  Text _buildMessage() {
    return (message != null)
        ? Text(
            message,
            style: TextStyles.paragraph(TextSize.small),
          )
        : null;
  }

  List<Widget> _buildActions() {
    if (message != null) {
      if (message.contains("401")) {
        return [
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(ctx).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                  (r) => false);
            },
          )
        ];
      }
    }

    if (actions != null) {
      return actions;
    }

    return null;
  }

  static void showErrorDialog(BuildContext context, String message) {
    if (Platform.isAndroid) {
      showDialog(
          barrierDismissible: !message.contains("401"),
          context: context,
          builder: (context) => AlertDialog(
                title: Text(_getErrorTitle()),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if (message.contains("401")) {
                        _navigateToSignIn(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ));
    } else {
      showCupertinoDialog(
          barrierDismissible: !message.contains("401"),
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text(_getErrorTitle()),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      if (message.contains("401")) {
                        _navigateToSignIn(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ));
    }
  }

  static void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => SignInScreen(),
        ),
        (r) => false);
  }

  static String _getErrorTitle() {
    if (Utils.appLanguage != null) {
      if (Utils.appLanguage.contains("pt")) {
        return "Erro";
      }
    }
    return "Error";
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Material(
            type: MaterialType.transparency,
            child: Center(
                child: Center(
                    child:
                        Platform.isIOS ? _iosLoading() : _androidLoading()))));
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
