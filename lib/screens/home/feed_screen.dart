import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/nav_drawer.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: CustomAppBar(
          titleImg: 'assets/navlogo.png',
          center: true,
        ),
        body: SafeArea(
          child: Text('ola'),
        ),
      ),
    );
  }
}
