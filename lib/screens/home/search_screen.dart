import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/nav_drawer.dart';
import 'package:skilla/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'searchScreen';
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: CustomAppBar(
          titleImg: 'assets/navlogo.png',
          center: true,
          widgets: [
            FlatButton(
              onPressed: () {},
              child: Icon(
                FeatherIcons.plusSquare,
                color: kSkillaPurple,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Text('SearchScreen'),
        ),
      ),
    );
  }
}
