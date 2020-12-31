import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/user_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String welcomeMsg = "Welcome, ";
    final welcomeTxt = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: FutureBuilder<User>(
            future: UserService().getProfileInfoFromPreferences(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Text(welcomeMsg + snapshot.data.firstName + "!",
                    style:
                        TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold));
              }
              return Text("Welcome",
                  style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold)); // unreachable
            }));

    final welcomeImg = SizedBox(
        height: 300.0,
        child: SvgPicture.asset("assets/images/undraw_welcoming.svg"));

    final categoryCard = SizedBox(
        height: 100.0,
        child: Card(
            child: ListTile(
                leading: FaIcon(FontAwesomeIcons.fileAlt,
                    size: 32.0, color: Theme.of(context).primaryColorDark),
                onTap: () {
                  Navigator.of(context).pushNamed(ROUTE_SENTENCES_LIST);
                },
                title: Padding(
                    padding: const EdgeInsets.all(DEFAULT_PADDING),
                    child: Text("Sentences Library")))));

    return Scaffold(
        appBar: AppBar(
            title: Text(APPNAME),
            leading: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FaIcon(FontAwesomeIcons.home))),
        body: Container(
            color: bgPrimaryColor,
            padding: EdgeInsets.all(8.0),
            child: ListView(children: [welcomeTxt, welcomeImg, categoryCard])));
  }
}
