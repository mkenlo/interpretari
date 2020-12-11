import 'dart:async' show Timer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/strings.dart';

class SplashScreen extends StatefulWidget {
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: Center(
          child: Text(APPNAME,
              style: GoogleFonts.patuaOne(color: Colors.white, fontSize: 36.0)),
        ));
  }

  void launchNextPage() {
    SharedPreferences.getInstance().then((prefInstance) {
      if (prefInstance.containsKey("sourceLanguage") ||
          prefInstance.containsKey("targetLanguage")) {
        Navigator.of(context).pushNamed(ROUTE_DASHBOARD);
      } else {
        Navigator.of(context).pushNamed(ROUTE_ONBOARDING);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), launchNextPage);
  }
}
