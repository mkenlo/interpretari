import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/strings.dart';
import 'home_screen.dart';
import 'translation_list_screen.dart';
import 'userprofile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return TranslationListScreen();
      case 2:
        return UserProfileScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = BottomNavigationBar(
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home), label: ROUTE_HOME),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.language),
            label: ROUTE_TRANSLATIONS_LIST),
        BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            label: ROUTE_USERPROFILE),
      ],
    );

    return Scaffold(body: getPage(_selectedIndex), bottomNavigationBar: bottom);
  }
}
