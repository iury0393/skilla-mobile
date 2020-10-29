import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/components/custom_app_bar.dart';
import 'package:skilla/components/post_item.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/utils.dart';

class FeedScreen extends StatefulWidget {
  static const String id = 'feedScreen';
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: Utils.getPaddingDefault(),
            child: Column(
              children: [
                PostItem(),
                PostItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
