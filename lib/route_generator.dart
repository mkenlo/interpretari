import 'package:flutter/material.dart';

import 'res/strings.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/preferences_screen.dart';
import 'screens/sentence_list_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/translation_list_screen.dart';
import 'screens/translation_screen.dart';
import 'screens/userprofile_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case ROUTE_PREFS:
        return MaterialPageRoute(builder: (_) => PreferenceScreen());
      case ROUTE_DASHBOARD:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case ROUTE_SENTENCES_LIST:
        return MaterialPageRoute(builder: (_) => SentenceListScreen());
      case ROUTE_TRANSLATE_SENTENCE:
        return MaterialPageRoute(
            builder: (_) => TranslationScreen(sentence: args));
      case ROUTE_USERPROFILE:
        return MaterialPageRoute(builder: (_) => UserProfileScreen());
      case ROUTE_SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case ROUTE_SIGNIN:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case ROUTE_TRANSLATIONS_LIST:
        return MaterialPageRoute(builder: (_) => TranslationListScreen());
      case ROUTE_HOME:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case ROUTE_ONBOARDING:
        return MaterialPageRoute(builder: (_) => OnBoardingScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
