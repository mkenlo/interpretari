import 'dart:convert';

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';
import '../models/user_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/language_service.dart';
import '../services/user_service.dart';
import 'error_screen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State createState() {
    return UserProfileScreenState();
  }
}

class UserProfileScreenState extends State<UserProfileScreen> {
  Language preferredSourceLanguage;
  Language preferredTargetLanguage;

  @override
  void initState() {
    getPreferredLanguage().then((values) {
      setState(() {
        preferredSourceLanguage = values[0];
        preferredTargetLanguage = values[1];
      });
    });
    super.initState();
  }

  void _setPreferredSourceLang(Language preferredLang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sourceLanguage", json.encode(preferredLang));

    setState(() {
      preferredSourceLanguage = preferredLang;
    });
  }

  void _setPreferredTargetLang(Language preferredLang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("targetLanguage", json.encode(preferredLang));

    setState(() {
      preferredTargetLanguage = preferredLang;
    });
  }

  void _changeSourceLanguage() {
    Widget languages = FutureBuilder(
      future: fetchLanguages("type=foreign"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return ErrorScreen(errorType.noConnection);
        }
        if (snapshot.hasError) {
          return ErrorScreen(errorType.exception);
        }
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      _setPreferredSourceLang(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                    highlightColor: Theme.of(context).primaryColorLight,
                    child: ListTile(
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].code)));
              });
        } else
          return Center(child: CircularProgressIndicator());
      },
    );

    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Change Language"), content: languages);
        });
  }

  void _changeTargetLanguage() {
    Widget languages = FutureBuilder(
      future: fetchLanguages("type=local"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return ErrorScreen(errorType.noConnection);
        }
        if (snapshot.hasError) {
          return ErrorScreen(errorType.exception);
        }
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      _setPreferredTargetLang(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                    highlightColor: Theme.of(context).primaryColorLight,
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].code),
                    ));
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Change Language"), content: languages);
        });
  }

  _buildPreferencesContent(User profile) {
    String fullName = "";
    String username = "Not yet logged In";
    if (profile != null) {
      fullName = profile.fullName();
      username = profile.username;
    }
    final Widget name = ListTile(
        leading: FaIcon(FontAwesomeIcons.user,
            color: Theme.of(context).primaryColorDark),
        title: Text(fullName,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
        subtitle: Text(username));

    final sourceLang = ListTile(
        leading:
            Icon(Icons.language, color: Theme.of(context).primaryColorDark),
        title: Text("Source Language"),
        subtitle: Text(preferredSourceLanguage.name),
        onTap: () {
          _changeSourceLanguage();
        });

    final targetLang = ListTile(
        leading:
            Icon(Icons.translate, color: Theme.of(context).primaryColorDark),
        title: Text("Target Language"),
        subtitle: Text(preferredTargetLanguage.name),
        onTap: () {
          _changeTargetLanguage();
        });

    final loginStatus = ListTile(
        leading:
            Icon(Icons.exit_to_app, color: Theme.of(context).primaryColorDark),
        title: Text((profile != null) ? "Logout" : "Login",
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.bold)),
        onTap: () {
          if (profile != null) {
            UserService().doLogout();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else
            Navigator.of(context).pushNamed(ROUTE_SIGNIN);
        });

    return Container(
        child: ListView(children: [name, sourceLang, targetLang, loginStatus]));
  }

  @override
  Widget build(BuildContext context) {
    final content = FutureBuilder<User>(
      future: UserService().getProfileInfoFromPreferences(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ErrorScreen(errorType.noConnection);
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return _buildPreferencesContent(snapshot.data);
        }
        return null; // unreachable
      },
    );

    return Scaffold(
        appBar: AppBar(
            title: Text("Settings"),
            leading: Padding(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: FaIcon(FontAwesomeIcons.slidersH))),
        body: Container(color: bgPrimaryColor, child: content));
  }
}
