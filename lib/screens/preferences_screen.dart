import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/language_service.dart';

class PreferenceScreen extends StatefulWidget {
  @override
  State createState() => PreferenceScreenState();
}

class PreferenceScreenState extends State<PreferenceScreen> {
  Language _preferredSourceLang;
  Language _preferredTargetLang;
  bool _micPermission = false;
  bool _storagePermission = false;
  List<Language> targetLanguages = [];
  List<Language> sourceLanguages = [];

  Widget _loadDropDownItems(List<Language> data, String languageType) {
    String hint =
        (languageType == "source") ? "Source Language" : "Target Language";

    return DropdownButtonFormField(
        decoration:
            InputDecoration(labelText: hint, border: OutlineInputBorder()),
        value: (languageType == "source")
            ? _preferredSourceLang
            : _preferredTargetLang,
        onChanged: (selected) {
          setState(() {
            if (languageType == "target") {
              _preferredTargetLang = selected;
            } else if (languageType == "source") {
              _preferredSourceLang = selected;
            }
          });
        },
        items: data.map<DropdownMenuItem>((lang) {
          return DropdownMenuItem<Language>(
              value: lang, child: Text(lang.name));
        }).toList());
  }

  Widget _buildLanguageDropDown(String languageType) {
    String queryFilter =
        (languageType == "source") ? "type=foreign" : "type=local";
    return FutureBuilder(
        future: fetchLanguages(queryFilter),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              if (!snapshot.hasData)
                return Text(
                    "Error: No Data Found"); // @TODO write a widget component for Error Messages
              return Text("Error: No connection");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return Text(snapshot.error.toString());

              return _loadDropDownItems(snapshot.data, languageType);
          }
          return null;
        });
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushNamed(ROUTE_SIGNIN);
  }

  void _askForPreferences() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              title: Text(TITLE_PREF_APPBAR),
              content: Text(LABEL_PREF_MSG_CHOICE),
              actions: <Widget>[
                FlatButton(
                    child: Text(LABEL_ACKNOW),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).accentColor)
              ]);
        });
  }

  Future<bool> _setLanguagesPreferences() async {
    if (_preferredTargetLang == null || _preferredSourceLang == null) {
      _askForPreferences();
      return false;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'sourceLanguage', json.encode(_preferredSourceLang));
      await prefs.setString(
          'targetLanguage', json.encode(_preferredTargetLang));
      return true;
    }
  }

  Widget _buildPermissionWidget() {
    final micPermissionWidget = SwitchListTile.adaptive(
        title: Text("Microphone"),
        value: _micPermission,
        onChanged: (state) {
          if (state) Permission.microphone.request();
          setState(() {
            _micPermission = state;
          });
        });
    final storagePermissionWidget = SwitchListTile.adaptive(
      title: Text('Storage'),
      value: _storagePermission,
      onChanged: (bool value) {
        if (value) Permission.storage.request();
        setState(() {
          _storagePermission = value;
        });
      },
    );
    return Column(children: [micPermissionWidget, storagePermissionWidget]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO export this button widget as a custom button for the app. This code is used on another page
    final doneButton = Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(30.0)),
        child: FlatButton(
            onPressed: () {
              _setLanguagesPreferences().then((isLanguageSaved) {
                if (isLanguageSaved) _navigateToNextPage();
              });
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.done_all, color: Colors.white),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10.0),
                  child: Text(BTN_APPLY,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)))
            ])));

    return Scaffold(
        appBar: AppBar(
            leading: Padding(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: FaIcon(FontAwesomeIcons.slidersH)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColorDark,
            title: Text(TITLE_PREF_APPBAR)),
        body: Container(
            constraints: BoxConstraints.expand(),
            color: bgPrimaryColor,
            padding: EdgeInsets.all(DEFAULT_PADDING),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: Center(
                          child: Text(LABEL_PREF_HEADER,
                              style: Theme.of(context).textTheme.headline5))),
                  Padding(
                      padding: EdgeInsets.all(DEFAULT_PADDING),
                      //child: _buildLanguageDropDown("source")),
                      child: _loadDropDownItems(sourceLanguages, "source")),
                  Padding(
                      padding: EdgeInsets.all(DEFAULT_PADDING),
                      //child: _buildLanguageDropDown("target")),
                      child: _loadDropDownItems(targetLanguages, "target")),
                  Expanded(
                      child: Center(
                          child: Text(LABEL_SET_PERMISSIONS,
                              style: Theme.of(context).textTheme.headline5))),
                  Padding(
                      child: _buildPermissionWidget(),
                      padding: EdgeInsets.all(DEFAULT_PADDING)),
                  doneButton
                ])));
  }

  @override
  void initState() {
    super.initState();

    filterLanguagesByType().then((languages) {
      setState(() {
        this.sourceLanguages = languages[0];
        this.targetLanguages = languages[1];
        _preferredSourceLang = languages[0][0];
        _preferredTargetLang = languages[1][0];
      });
    });
  }
}
