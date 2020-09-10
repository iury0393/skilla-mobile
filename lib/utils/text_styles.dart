import 'package:flutter/material.dart';

class TextSize {
  static const double xSmall = 12.0;
  static const double small = 14.0;
  static const double medium = 16.0;
  static const double large = 18.0;
  static const double xLarge = 20;
  static const double xxLarge = 24;
}

class TextStyles {
  static TextStyle appBarTitle({Color textColor}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: TextSize.large,
        color: textColor != null ? textColor : Colors.black,
        fontWeight: FontWeight.bold);
  }

  static TextStyle paragraph(double size,
      {FontWeight weight,
      String fontName,
      Color color,
      double lineHeight,
      bool isLink = false}) {
    return TextStyle(
        fontFamily: fontName != null ? fontName : 'Roboto',
        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
        fontSize: size,
        height: lineHeight != null ? lineHeight : 1.30,
        color: color != null ? color : Colors.black,
        fontWeight: weight != null ? weight : FontWeight.normal);
  }

  static TextStyle textField(double size, {FontWeight weight, Color color}) {
    return TextStyle(
        fontFamily: 'Roboto',
        fontSize: size,
        color: color != null ? color : Colors.black,
        fontWeight: weight != null ? weight : FontWeight.normal);
  }

  static TextStyle btnTitle(Color color) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: TextSize.medium,
      fontWeight: FontWeight.bold,
      color: color != null ? color : Colors.black,
    );
  }
}
