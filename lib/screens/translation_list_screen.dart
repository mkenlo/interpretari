import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/translation_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../services/translation_service.dart';
import '../services/user_service.dart';
import 'error_screen.dart';

class TranslationListScreen extends StatefulWidget {
  TranslationListScreen({Key key}) : super(key: key);

  @override
  _TranslationListScreenState createState() => _TranslationListScreenState();
}

class _TranslationListScreenState extends State<TranslationListScreen> {
  int userId;

  @override
  void initState() {
    super.initState();

    UserService().getProfileInfoFromPreferences().then((user) {
      setState(() {
        this.userId = user.id;
      });
    });
  }

  Widget _buildListWidget(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          Translation item = data[index];
          return ListTile(
              title: Text(item.sentence.text),
              subtitle: Text(item.recordedOn),
              trailing: Icon(Icons.play_circle_outline));
        });
  }

  Widget _noDataWidget() {
    return Container(
        color: Color(0xFFF3F8F7),
        padding: EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: Icon(Icons.data_usage,
                  size: 128.0, color: Theme.of(context).accentColor)),
          Expanded(
              child: Column(
            children: <Widget>[
              Text(
                "You haven't recorded anything yet",
                style: TextStyle(color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
            ],
          ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final content = FutureBuilder(
      future: fetchTranslation(userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            if (!snapshot.hasData) return ErrorScreen(errorType.noData);
            return ErrorScreen(errorType.noConnection);
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) return ErrorScreen(errorType.exception);
            if (snapshot.data.length > 0)
              return _buildListWidget(snapshot.data);

            return _noDataWidget();
        }
        return null;
      },
    );

    return Scaffold(
        appBar: AppBar(
            title: Text("Translations History"),
            leading: Padding(
                padding: const EdgeInsets.all(DEFAULT_PADDING),
                child: FaIcon(FontAwesomeIcons.language))),
        body: Container(color: bgPrimaryColor, child: Center(child: content)));
  }
}
