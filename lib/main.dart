import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skilla/bloc/splash_bloc.dart';
import 'package:skilla/model/auth.dart';
import 'package:skilla/network/config/base_response.dart';
import 'package:skilla/screens/home/feed_screen.dart';
import 'package:skilla/screens/home/opportunities_screen.dart';
import 'package:skilla/screens/home/profile_screen.dart';
import 'package:skilla/screens/home/search_screen.dart';
import 'package:skilla/screens/home/tab_bar_screen.dart';
import 'package:skilla/screens/intro/intro_screen.dart';
import 'package:skilla/screens/intro/splash_screen.dart';
import 'package:skilla/utils/appLocalizations.dart';
import 'package:skilla/utils/utils.dart';
import 'package:splashscreen/splashscreen.dart';

final _bloc = SplashBloc();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _bloc.getDataFromDB();

  _bloc.authStreamController.stream.listen((event) async {
    switch (event.status) {
      case Status.LOADING:
        break;
      case Status.ERROR:
        await Utils.cleanDataBase();
        _bloc.dispose();
        runApp(MyApp(event.data));
        break;
      case Status.COMPLETED:
        _bloc.dispose();
        runApp(MyApp(event.data));
        break;
    }
  });
}

class MyApp extends StatelessWidget {
  final Auth auth;

  MyApp(this.auth, {Key key}) : super(key: key);

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
      home: auth != null ? TabBarScreen() : SplashPage(),
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
