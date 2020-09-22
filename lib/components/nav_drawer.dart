import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skilla/screens/home/explore_screen.dart';
import 'package:skilla/screens/home/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/text_styles.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                '',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.home,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuFeed'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {_onNavigateToFeedScreen(context)},
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.user,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuProfile'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {_onNavigateToProfileScreen(context)},
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.award,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuOpportunities'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {_onNavigateToOpportunitiesScreen(context)},
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.globe,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuExplore'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {_onNavigateToExploreScreen(context)},
            ),
            ListTile(
              leading: Icon(
                FeatherIcons.search,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuSearch'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {_onNavigateToSearchScreen(context)},
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: kSkillaPurple,
              ),
              title: Text(
                AppLocalizations.of(context).translate('menuExit'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.w400,
                ),
              ),
              onTap: () => {Navigator.of(context).pop()},
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigateToFeedScreen(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => FeedScreen(),
      ),
    );
  }

  void _onNavigateToProfileScreen(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  void _onNavigateToOpportunitiesScreen(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => OpportunitiesScreen(),
      ),
    );
  }

  void _onNavigateToExploreScreen(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ExploreScreen(),
      ),
    );
  }

  void _onNavigateToSearchScreen(context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SearchScreen(),
      ),
    );
  }
}
