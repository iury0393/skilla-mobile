import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skilla/screens/home/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/screens/home/tab_bar_screen.dart';
import 'package:skilla/screens/intro/intro_screen.dart';
import 'package:skilla/screens/intro/splash_screen.dart';
import 'package:skilla/screens/signFlow/sign_in_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/utils.dart';

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
      localeResolutionCallback: (Locale locale, supportedLocales) {
        return getDeviceLanguage(locale, supportedLocales);
      },
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
        TabBarScreen.id: (context) => TabBarScreen(),
        FeedScreen.id: (context) => FeedScreen(),
        OpportunitiesScreen.id: (context) => OpportunitiesScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        SearchScreen.id: (context) => SearchScreen(),
      },
    );
  }

  Locale getDeviceLanguage(Locale locale, Iterable<Locale> supportedLocales) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          if (supportedLocale.languageCode == "pt") {
            Utils.appLanguage = '${supportedLocale}_BR';
          } else if (supportedLocale.languageCode == "en") {
            Utils.appLanguage = 'en';
          } else {
            Utils.appLanguage = 'es';
          }
          return supportedLocale;
        }
      }
      Utils.appLanguage = 'en';
      return Locale('en');
    }
    Utils.appLanguage = 'en';
    return Locale('en');
  }
}
