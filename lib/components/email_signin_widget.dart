import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/dimensions.dart';
import '../services/user_service.dart';

class EmailSignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                labelText: 'Email')),
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
                labelText: 'Password')),
        padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING));

    Widget signInButton = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
            border:
                Border.all(width: 2.0, color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(30.0)),
        child: InkWell(
            onTap: () {
              UserService().doLogin();
            },
            child: Center(
                child: Text("Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark)))));

    return Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: ListView(
            children: [nameInput, emailInput, passwordInput, signInButton]));
  }
}
