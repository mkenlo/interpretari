import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/dimensions.dart';
import '../res/strings.dart';

class SignInScreen extends StatefulWidget {
  @override
  State createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  void _navigateToNextPage() {
    /*if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }*/
    Navigator.of(context).pushNamed(ROUTE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    Widget facebookWidget = Container(
        margin:
            EdgeInsets.symmetric(vertical: DEFAULT_PADDING, horizontal: 0.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(30.0)),
        child: ListTile(
            onTap: () {
              print("_doLogin");
            },
            leading: FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
            title: Text("Continue with Facebook",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0))));
    Widget nameInput = Container(
        child: TextField(
            obscureText: false,
            decoration: InputDecoration(
                prefixIcon: Padding(
                    child: FaIcon(FontAwesomeIcons.user, size: DEFAULT_PADDING),
                    padding: EdgeInsets.all(DEFAULT_PADDING)),
                border: OutlineInputBorder(),
                labelText: 'FullName')),
        padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING));
    Widget emailInput = Container(
        child: TextField(
          obscureText: false,
          decoration: InputDecoration(
              prefixIcon: Padding(
                  child: FaIcon(FontAwesomeIcons.at, size: DEFAULT_PADDING),
                  padding: EdgeInsets.all(DEFAULT_PADDING)),
              border: OutlineInputBorder(),
              labelText: 'Email'),
        ),
        padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING));
    Widget passwordInput = Container(
        child: TextField(
          obscureText: true,
          obscuringCharacter: "*",
          decoration: InputDecoration(
              prefixIcon: Padding(
                  child: FaIcon(FontAwesomeIcons.lock, size: DEFAULT_PADDING),
                  padding: EdgeInsets.all(DEFAULT_PADDING)),
              border: OutlineInputBorder(),
              labelText: 'Password'),
        ),
        padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING));
    Widget signInButton = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
            border:
                Border.all(width: 2.0, color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(30.0)),
        child: InkWell(
            onTap: () {
              print("_doLogin");
            },
            child: Center(
                child: Text("Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark)))));
    Widget content = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: ListView(
          children: [
            nameInput,
            emailInput,
            passwordInput,
            signInButton,
            LimitedBox(child: Center(child: Text("or")), maxHeight: 80.0),
            facebookWidget
          ],
        ));
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: FaIcon(FontAwesomeIcons.times, color: Colors.white),
                onPressed: () {
                  _navigateToNextPage();
                }),
            centerTitle: true,
            title: Text("Create a profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColorDark,
            elevation: 0.0),
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: content)],
        )));
  }

  @override
  void initState() {
    super.initState();
  }
}
