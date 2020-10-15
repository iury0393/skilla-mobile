import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profileScreen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Text('ProfileScreen'),
        ),
      ),
    );
  }
}
