import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/screens/home/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/utils/constants.dart';

class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key key}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List<Widget> tabs;
  PageController _myPage = PageController(initialPage: 3);

  bool isSelectedFeed = false;
  bool isSelectedOpportunities = false;
  bool isSelectedSearch = false;
  bool isSelectedProfile = false;

  @override
  void initState() {
    super.initState();
    isSelectedFeed = true;
    tabs = [
      SafeArea(child: FeedScreen()),
      SafeArea(child: OpportunitiesScreen()),
      SafeArea(child: SearchScreen()),
      SafeArea(child: ProfileScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _myPage,
          children: tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: BottomAppBar(
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 28.0,
                  icon: Icon(
                    FeatherIcons.home,
                    color: isSelectedFeed ? kSkillaPurple : kPurpleLighterColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isSelectedFeed = true;
                      isSelectedOpportunities = false;
                      isSelectedSearch = false;
                      isSelectedProfile = false;
                      _myPage.jumpToPage(0);
                    });
                  },
                ),
                IconButton(
                  iconSize: 28.0,
                  icon: Icon(
                    FeatherIcons.award,
                    color: isSelectedOpportunities
                        ? kSkillaPurple
                        : kPurpleLighterColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isSelectedFeed = false;
                      isSelectedOpportunities = true;
                      isSelectedSearch = false;
                      isSelectedProfile = false;
                      _myPage.jumpToPage(1);
                    });
                  },
                ),
                IconButton(
                  iconSize: 28.0,
                  icon: Icon(
                    FeatherIcons.search,
                    color:
                        isSelectedSearch ? kSkillaPurple : kPurpleLighterColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isSelectedFeed = false;
                      isSelectedOpportunities = false;
                      isSelectedSearch = true;
                      isSelectedProfile = false;
                      _myPage.jumpToPage(2);
                    });
                  },
                ),
                IconButton(
                  iconSize: 28.0,
                  icon: Icon(
                    FeatherIcons.user,
                    color:
                        isSelectedProfile ? kSkillaPurple : kPurpleLighterColor,
                  ),
                  onPressed: () {
                    setState(() {
                      isSelectedFeed = false;
                      isSelectedOpportunities = false;
                      isSelectedSearch = false;
                      isSelectedProfile = true;
                      _myPage.jumpToPage(3);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
