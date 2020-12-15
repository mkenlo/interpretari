import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/user_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  State createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  void showErrors(String errorMsg) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              title: Text("Login Error"),
              content: Text(errorMsg),
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

  void _navigateToNextPage() {
    Navigator.of(context).pushNamed(ROUTE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    Widget facebookButton = Container(
        margin:
            EdgeInsets.symmetric(vertical: DEFAULT_PADDING, horizontal: 0.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(30.0)),
        child: ListTile(
            onTap: () async {
              final res = await UserService().fbLogin();
              if (res < 0) {
                showErrors("SERVER ERROR: Could not process login");
              } else if (res == 0) {
                showErrors("User cancelled the Login");
              } else {
                _navigateToNextPage();
              }
            },
            leading: FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
            title: Text("Login with Facebook",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0))));

    Widget signInButton = Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 2.0,
              //color: Theme.of(context).accentColor, // TODO Change back to acccent color when this button is enable
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: ListTile(
            enabled: false,
            leading: FaIcon(FontAwesomeIcons.envelope),
            title: Text(
              "Login with email",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            )));

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
            padding: EdgeInsets.all(DEFAULT_PADDING),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Placeholder for email_signin_widget
              SizedBox(
                  height: 300.0,
                  child: SvgPicture.asset('assets/images/undraw_sign_in.svg')),
              // TODO Change this placeholder widget with the email_signin_widget Or Activate Button
              signInButton,
              facebookButton
            ])));
  }

  @override
  void initState() {
    super.initState();
  }
}
