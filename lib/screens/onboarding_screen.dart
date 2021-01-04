import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/dimensions.dart';
import '../res/strings.dart';

class OnBoardingScreen extends StatelessWidget {
  void launchNextPage(BuildContext context) {
    SharedPreferences.getInstance().then((prefInstance) {
      if (prefInstance.containsKey("sourceLanguage") ||
          prefInstance.containsKey("targetLanguage")) {
        Navigator.of(context).pushNamed(ROUTE_DASHBOARD);
      } else {
        Navigator.of(context).pushNamed(ROUTE_PREFS);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getStartedButton = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2.0, color: Colors.white60),
            borderRadius: BorderRadius.circular(30.0)),
        child: InkWell(
            onTap: () {
              launchNextPage(context);
            },
            child: Center(
                child: Text("Get Started",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Theme.of(context).accentColor)))));

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: Container(
            padding: EdgeInsets.fromLTRB(
                DEFAULT_PADDING, 100.0, DEFAULT_PADDING, DEFAULT_PADDING),
            color: Theme.of(context).primaryColorDark,
            child: Column(children: [
              Expanded(
                  child: Text(APPNAME,
                      style: GoogleFonts.patuaOne(
                          color: Colors.white, fontSize: 56.0)),
                  flex: 3),
              Expanded(
                  flex: 4,
                  child: Text("", //TODO Add App Slogan Here
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black45))),
              getStartedButton
            ])));
  }
}
