import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sentence_list_screen.dart';
import 'userprofile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<String> _pagesTitle = ["Translate", "My Translations", "Profile"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return SentenceListScreen();
      case 1:
        return Text("User List Translations Screen");
      case 2:
        return UserProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.translate),
          title: Text('My Translations'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Me'),
        ),
      ],
    );

    return Scaffold(
        /* appBar: AppBar(
          title: Text(_pagesTitle[_selectedIndex]),
        ),*/
        body: getPage(_selectedIndex),
        bottomNavigationBar: bottom);
  }
}
