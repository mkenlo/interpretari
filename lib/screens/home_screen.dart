import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<String> categories = ["Sentences Book", "Translation History"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(APPNAME),
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FaIcon(FontAwesomeIcons.home),
            )),
        body: Container(
            color: bgPrimaryColor,
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                    height: 100.0,
                    child: Card(
                        child: ListTile(
                            leading: FaIcon(FontAwesomeIcons.fileAlt,
                                size: 32.0,
                                color: Theme.of(context).primaryColorDark),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ROUTE_SENTENCES_LIST);
                            },
                            title: Padding(
                                padding: const EdgeInsets.all(DEFAULT_PADDING),
                                child: Text(categories[0]))))),
                SizedBox(
                  height: 100.0,
                  child: Card(
                      child: ListTile(
                          leading: FaIcon(FontAwesomeIcons.language,
                              size: 32.0,
                              color: Theme.of(context).primaryColorDark),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ROUTE_TRANSLATIONS_LIST);
                          },
                          title: Padding(
                              padding: const EdgeInsets.all(DEFAULT_PADDING),
                              child: Text(categories[1])))),
                )
              ],
            )));
  }
}
/*

class CategoryCardWidget extends StatelessWidget {
  final Widget categoryIcon;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: Card(
          child: ListTile(
              leading: FaIcon(FontAwesomeIcons.language,
                  size: 64.0, color: Theme.of(context).primaryColorDark),
              onTap: () {
                Navigator.of(context).pushNamed(ROUTE_TRANSLATIONS_LIST);
              },
              title: Padding(
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  child: Text(categoryName,
                      style: Theme.of(context).textTheme.headline5)))),
    );
  }

  CategoryCardWidget(this.categoryIcon, this.categoryName);
}
*/
