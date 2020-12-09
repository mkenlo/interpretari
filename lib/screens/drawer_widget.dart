import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/strings.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
      ),
      ListTile(
        leading: FaIcon(FontAwesomeIcons.quoteLeft,
            color: Theme.of(context).primaryColorDark),
        title: Text('Sentences'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.of(context).pushReplacementNamed(ROUTE_SENTENCES_LIST);
        },
      ),
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.recordVinyl,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text('My Translations'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ROUTE_TRANSLATIONS_LIST);
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.cogs,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text('Settings'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.of(context).pushReplacementNamed(ROUTE_USERPROFILE);
        },
      ),
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.bowlingBall,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text('About Us'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.bowlingBall,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text('Login'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.of(context).pushReplacementNamed(ROUTE_SIGNIN);
        },
      ),
      ListTile(
        leading: FaIcon(
          FontAwesomeIcons.bowlingBall,
          color: Theme.of(context).primaryColorDark,
        ),
        title: Text('Login'),
        onTap: () {
          // Update the state of the app
          // ...
          // Then close the drawer
          Navigator.of(context).pushReplacementNamed(ROUTE_SIGNUP);
        },
      ),
    ]);
  }
}
