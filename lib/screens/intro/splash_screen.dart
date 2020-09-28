import 'package:flutter/material.dart';
import 'package:skilla/utils/constants.dart';
import 'package:splashscreen/splashscreen.dart';

import 'intro_screen.dart';

class SplashPage extends StatefulWidget {
  static const String id = 'splashScreen';
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 5,
          gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [kPurpleLightColor, kPurpleLighterColor],
          ),
          navigateAfterSeconds: IntroScreen(),
          loaderColor: kTransparent,
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"),
                fit: BoxFit.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
