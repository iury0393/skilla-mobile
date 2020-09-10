import 'package:flutter/material.dart';
import 'package:skilla/utils/text_styles.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final Color titleColor;
  final Color borderColor;
  final Color backgroundColor;
  final double width;
  final double height;
  final GestureTapCallback onPressed;

  const RoundedButton({
    this.title,
    this.titleSize,
    this.titleColor,
    this.borderColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 0.0,
      color: backgroundColor,
      textColor: titleColor,
      child: SizedBox(
        width: width != null ? width : MediaQuery.of(context).size.width,
        height: height != null ? height : 54.0,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: titleSize != null ? titleSize : TextSize.medium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: borderColor),
      ),
    );
  }
}
