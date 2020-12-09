import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/dimensions.dart';

enum errorType { noConnection, exception, noData }

String errorTypeToMessage(errorType err) {
  switch (err) {
    case errorType.noConnection:
      return "Please check your internet connection and try again";
      break;
    case errorType.noData:
      return "No data available";
      break;
    default: // Without this, you see a WARNING.
      return "Something went wrong. The operation could not be completed."; //
  }
}

class ErrorScreen extends StatelessWidget {
  final errorType _message;

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child: Wrap(children: [
          Padding(
              padding: EdgeInsets.all(DEFAULT_PADDING),
              child: FaIcon(FontAwesomeIcons.exclamationTriangle,
                  color: Theme.of(context).primaryColorDark)),
          Text(
            errorTypeToMessage(_message),
            style: TextStyle(color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ]));
  }

  ErrorScreen(this._message);
}
