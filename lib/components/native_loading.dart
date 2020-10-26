import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/utils/constants.dart';

class NativeLoading extends StatelessWidget {
  final bool animating;

  NativeLoading({
    Key key,
    this.animating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _iosLoading() : _androidLoading();
  }

  _iosLoading() {
    return CupertinoActivityIndicator(
      animating: true, //animating,
    );
  }

  _androidLoading() {
    return Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: kSkillaPurple,
      ),
    );
  }
}
