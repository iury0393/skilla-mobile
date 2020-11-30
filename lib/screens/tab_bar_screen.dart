import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:skilla/Feed/feed_screen.dart';
import 'package:skilla/Profile/profile_screen.dart';
import 'package:skilla/Search/search_screen.dart';
import 'package:skilla/screens/opportunities_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/constants.dart';
import 'package:skilla/utils/event_center.dart';
import 'package:skilla/utils/text_styles.dart';

class TabBarScreen extends StatefulWidget {
  TabBarScreen({Key key}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List<Widget> tabs;
  PageController _myPage = PageController(initialPage: 3);
  int _currentIndex = 3;
  BannerAd myBanner;
  InterstitialAd myInterstitial;
  int clicks = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
      SafeArea(child: FeedScreen()),
      SafeArea(child: OpportunitiesScreen()),
      SafeArea(child: SearchScreen()),
      SafeArea(child: ProfileScreen()),
    ];

    // FirebaseAdMob.instance.initialize(appId: kAppId);
    //
    // startBanner();
    // displayBanner();
  }

  @override
  void dispose() {
    // myBanner?.dispose();
    // myInterstitial?.dispose();
    super.dispose();
    _myPage.dispose();
  }

  void scrollTop(isScrolling) {
    EventCenter.getInstance()
        .scrollEvent
        .broadcast(ScrollEventArgs(isScrolling));
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'technology',
      'mobile',
      'study',
      'udemy',
      'alura',
    ],
    childDirected: false,
    testDevices: <String>[],
  );

  void startBanner() {
    myBanner = BannerAd(
      adUnitId: kBannerId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        anchorType: AnchorType.bottom,
      );
  }

  InterstitialAd buildInterstitial() {
    return InterstitialAd(
        adUnitId: kInterstitialId,
        targetingInfo: MobileAdTargetingInfo(testDevices: <String>[]),
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myInterstitial?.show();
          }
          if (event == MobileAdEvent.clicked || event == MobileAdEvent.closed) {
            myInterstitial.dispose();
            clicks = 0;
          }
        });
  }

  void shouldDisplayTheAd() {
    clicks++;
    if (clicks >= 5) {
      myInterstitial = buildInterstitial()
        ..load()
        ..show();
      clicks = 0;
    }
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
        // margin: const EdgeInsets.only(bottom: 50),
        child: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            if (index == 0) {
              scrollTop(true);
            }
            // shouldDisplayTheAd();
            setState(() => _currentIndex = index);
            _myPage.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: Text(
                'Feed',
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                FeatherIcons.home,
                color: kSkillaPurple,
              ),
              textAlign: TextAlign.center,
              activeColor: kSkillaPurple,
            ),
            BottomNavyBarItem(
              title: Text(
                AppLocalizations.of(context).translate('titleTabBarJobs'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                FeatherIcons.award,
                color: kSkillaPurple,
              ),
              textAlign: TextAlign.center,
              activeColor: kSkillaPurple,
            ),
            BottomNavyBarItem(
              title: Text(
                AppLocalizations.of(context).translate('titleTabBarSearch'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                FeatherIcons.search,
                color: kSkillaPurple,
              ),
              textAlign: TextAlign.center,
              activeColor: kSkillaPurple,
            ),
            BottomNavyBarItem(
              title: Text(
                AppLocalizations.of(context).translate('titleTabBarProfile'),
                style: TextStyles.paragraph(
                  TextSize.small,
                  weight: FontWeight.bold,
                ),
              ),
              icon: Icon(
                FeatherIcons.user,
                color: kSkillaPurple,
              ),
              textAlign: TextAlign.center,
              activeColor: kSkillaPurple,
            ),
          ],
          curve: Curves.easeIn,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
    );
  }
}
