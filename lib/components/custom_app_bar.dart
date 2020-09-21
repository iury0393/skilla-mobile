import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleImg;
  final double progressBar;
  final Color backgroundColor;
  final List<Widget> widgets;
  final double height;
  final Color titleColor;
  final bool center;
  final TabBar tabBar;
  final IconThemeData iconThemeData;
  final Widget leading;

  const CustomAppBar({
    Key key,
    this.widgets,
    this.iconThemeData,
    this.titleImg,
    this.height,
    this.progressBar,
    this.backgroundColor,
    this.titleColor,
    this.center,
    this.tabBar,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading != null ? leading : null,
      bottom: tabBar != null ? tabBar : null,
      iconTheme: iconThemeData != null
          ? iconThemeData
          : IconThemeData(
              color: Colors.blue,
            ),
      centerTitle: center != null ? center : false,
      title: Padding(
        padding: EdgeInsets.all(10.0),
        child: Image.asset(titleImg, fit: BoxFit.cover),
      ),
      backgroundColor: backgroundColor != null ? backgroundColor : Colors.white,
      elevation: 0.0,
      brightness: Brightness.light,
      actions: widgets != null ? widgets : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height != null ? height : 50.0);
}
