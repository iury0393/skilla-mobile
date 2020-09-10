import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/utils/text_styles.dart';

Future<T> showNativeDialog<T>({BuildContext context, WidgetBuilder builder}) {
  if (Platform.isIOS) {
    return showCupertinoDialog(context: context, builder: builder);
  } else {
    return showDialog(
        barrierDismissible: false, context: context, builder: builder);
  }
}

class NativeDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;

  NativeDialog({Key key, this.title, this.message, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? iosDialog() : androidDialog();
  }

  CupertinoAlertDialog iosDialog() {
    return CupertinoAlertDialog(
      title: (title != null)
          ? Text(
              title,
              style:
                  TextStyles.paragraph(TextSize.small, weight: FontWeight.bold),
            )
          : null,
      content: (message != null)
          ? Text(
              message,
              style: TextStyles.paragraph(TextSize.small),
            )
          : null,
      actions: (actions != null) ? actions : null,
    );
  }

  AlertDialog androidDialog() {
    return AlertDialog(
      title: (title != null)
          ? Text(
              title,
              style:
                  TextStyles.paragraph(TextSize.small, weight: FontWeight.bold),
            )
          : null,
      content: (message != null)
          ? Text(
              message,
              style: TextStyles.paragraph(TextSize.small),
            )
          : null,
      actions: (actions != null) ? actions : null,
    );
  }
}
