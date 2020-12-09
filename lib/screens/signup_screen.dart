import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/dimensions.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Widget facebookWidget = Container(
        margin:
            EdgeInsets.symmetric(vertical: DEFAULT_PADDING, horizontal: 0.0),
        padding: EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: GestureDetector(
            onTap: () {
              print("_doLogin");
            },
            child: Row(children: [
              Image(
                  image: AssetImage("assets/images/f_logo_RGB-White_100.png"),
                  height: 24.0,
                  width: 24.0,
                  color: Colors.white),
              Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 10.0),
                  child: Text("Continue with Facebook",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0))),
            ])));
    Widget emailInput = Container(
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: FaIcon(FontAwesomeIcons.at, size: DEFAULT_PADDING),
              padding: EdgeInsets.all(DEFAULT_PADDING)),
          border: OutlineInputBorder(),
          labelText: 'Enter Email',
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
    );

    Widget firstNameInput = Container(
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Padding(
                child: FaIcon(FontAwesomeIcons.at, size: DEFAULT_PADDING),
                padding: EdgeInsets.all(DEFAULT_PADDING)),
            border: OutlineInputBorder(),
            labelText: 'Firstname'),
      ),
      padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
    );

    Widget lastNameInput = Container(
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: FaIcon(FontAwesomeIcons.at, size: DEFAULT_PADDING),
              padding: EdgeInsets.all(DEFAULT_PADDING)),
          border: OutlineInputBorder(),
          labelText: 'Lastname',
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
    );
    Widget passwordInput = Container(
      child: TextField(
        obscureText: true,
        obscuringCharacter: "*",
        decoration: InputDecoration(
          prefixIcon: Padding(
              child: FaIcon(FontAwesomeIcons.lock, size: DEFAULT_PADDING),
              padding: EdgeInsets.all(DEFAULT_PADDING)),
          border: OutlineInputBorder(),
          labelText: 'Enter Password',
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
    );
    Widget signInButton = ElevatedButton(
      child: Text('Sign up'),
      onPressed: () {},
    );
    Widget content = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadiusDirectional.vertical(top: Radius.circular(40.0))),
        child: ListView(
          children: [
            emailInput,
            lastNameInput,
            firstNameInput,
            passwordInput,
            Padding(
              padding: const EdgeInsets.all(DEFAULT_PADDING),
              child: signInButton,
            ),
            LimitedBox(
              child: Center(child: Text("or")),
              maxHeight: 30.0,
            ),
            facebookWidget,
          ],
        ));
    return Scaffold(
        body: Container(
            color: Theme.of(context).primaryColorDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
                  child: Text("Welcome",
                      style: Theme.of(context).textTheme.headline4),
                ),
                Padding(
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  child: Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Expanded(child: content)
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
  }
}
