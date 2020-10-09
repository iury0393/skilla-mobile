import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/utils/constants.dart';

class ExploreScreen extends StatefulWidget {
  static const String id = 'exploreScreen';
  ExploreScreen({Key key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildExplore(width, height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildExplore(double width, double height) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/post.jpg',
              width: width / 3,
              height: height / 5,
            ),
            Image.asset(
              'assets/post.jpg',
              width: width / 3,
              height: height / 5,
            ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}
