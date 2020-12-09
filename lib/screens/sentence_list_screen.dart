import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "../models/sentence_model.dart";
import '../res/strings.dart';
import "../services/sentence_service.dart";
import 'drawer_widget.dart';
import 'error_screen.dart';

class SentenceListScreen extends StatefulWidget {
  @override
  _SentenceListScreenState createState() => _SentenceListScreenState();
}

class _SentenceListScreenState extends State<SentenceListScreen> {
  Future<List<Sentence>> sentences;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<String> _getLanguagesFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("sourceLanguage");
  }

  Future<void> _refreshList() async {
    _getLanguagesFromPreferences().then((sourceLanguage) {
      setState(() {
        sentences = fetchSentences("language=$sourceLanguage");
      });
    });
  }

  Widget _loadSentencesWidget() {
    return FutureBuilder(
        future: sentences,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              if (!snapshot.hasData) return ErrorScreen(errorType.noData);
              return ErrorScreen(errorType.noConnection);
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                //return ErrorScreen(errorType.exception);
                return Text(snapshot.error.toString());
              }

              return _buildListWidget(snapshot.data);
          }
          return null;
        });
  }

  Widget _buildListWidget(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Sentence item = data[index];
          //return SentenceItem(phrase: item, index: index+1);
          return ListTile(
            onTap: () {
              _navigateToRecordingPage(item);
            },
            leading: FaIcon(
              FontAwesomeIcons.quoteLeft,
              color: Theme.of(context).primaryColorLight,
            ),
            focusColor: Theme.of(context).primaryColorLight,
            hoverColor: Theme.of(context).primaryColorLight,
            //contentPadding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
            title: Text(
              item.text,
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(item.language),
            // trailing: IconButton(icon: Icon(Icons.mic), onPressed: () {}),
          );
        });
  }

  void _navigateToRecordingPage(Sentence item) {
    Navigator.of(context).pushNamed(ROUTE_TRANSLATE_SENTENCE, arguments: item);
  }

  @override
  void initState() {
    super.initState();

    _getLanguagesFromPreferences().then((sourceLanguage) {
      setState(() {
        sentences = fetchSentences("language=$sourceLanguage");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text("Sentences"),
        actions: [
          FlatButton.icon(
              label: Text(""),
              onPressed: () {
                print("More button was pressed");
              },
              icon: Icon(Icons.more_vert, color: Colors.white))
        ]);
    final content = RefreshIndicator(
        child: _loadSentencesWidget(),
        key: _refreshIndicatorKey,
        onRefresh: () => _refreshList());
    return Scaffold(
      appBar: appBar,
      body: content,
      drawer: Drawer(child: DrawerWidget()),
    );
  }
}
