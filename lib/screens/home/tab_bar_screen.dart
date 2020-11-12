import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:skilla/screens/home/feed/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';

class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key key}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List<Widget> tabs;
  PageController _myPage = PageController(initialPage: 3);
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    tabs = [
      SafeArea(child: FeedScreen()),
      SafeArea(child: OpportunitiesScreen()),
      SafeArea(child: SearchScreen()),
      SafeArea(child: ProfileScreen()),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _myPage.dispose();
  }

  void scrollTop(isScrolling) {
    EventCenter.getInstance()
        .scrollEvent
        .broadcast(ScrollEventArgs(isScrolling));
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
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          if (index == 0) {
            scrollTop(true);
          }
          setState(() => _currentIndex = index);
          _myPage.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Feed'),
            icon: Icon(
              FeatherIcons.home,
              color: kSkillaPurple,
            ),
          ),
          BottomNavyBarItem(
            title: Text('Jobs'),
            icon: Icon(
              FeatherIcons.award,
              color: kSkillaPurple,
            ),
          ),
          BottomNavyBarItem(
            title: Text('Search'),
            icon: Icon(
              FeatherIcons.search,
              color: kSkillaPurple,
            ),
          ),
          BottomNavyBarItem(
            title: Text('Profile'),
            icon: Icon(
              FeatherIcons.user,
              color: kSkillaPurple,
            ),
          ),
        ],
      ),
    );
  }
}
