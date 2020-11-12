import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseInstance {
  static FirebaseAnalytics _analytics;

  static getFirebaseInstance() {
    if (_analytics == null) {
      _analytics = FirebaseAnalytics();
      return _analytics;
    }
    return _analytics;
  }
}
