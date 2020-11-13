import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';

class CustomFlushBar {
  static showFlushBar(String message, BuildContext ctx) {
    Flushbar(
      messageText: Text(message,
          style: TextStyles.paragraph(TextSize.medium,
              weight: FontWeight.w700, color: Colors.white)),
      duration: Duration(seconds: 2),
      boxShadows: [
        BoxShadow(
          color: Colors.red[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      backgroundColor: kRedColor,
    )..show(ctx);
  }
}
