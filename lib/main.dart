import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skilla/screens/home/explore_screen.dart';
import 'package:skilla/screens/home/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/screens/intro/intro_screen.dart';
import 'package:skilla/screens/intro/splash_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      title: 'Skilla',
      theme: ThemeData(
        canvasColor: Colors.transparent,
        primaryColor: Color(0xFF0695FF),
        indicatorColor: Color(0xFFEB008B),
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xFFFFF8E1),
        backgroundColor: Colors.white,
      ),
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialRoute: SplashPage.id,
      routes: {
        SplashPage.id: (context) => SplashPage(),
        IntroScreen.id: (context) => IntroScreen(),
        ExploreScreen.id: (context) => ExploreScreen(),
        FeedScreen.id: (context) => FeedScreen(),
        OpportunitiesScreen.id: (context) => OpportunitiesScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SearchScreen.id: (context) => SearchScreen(),
      },
    );
  }
}
