import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/dimensions.dart';

class TranslatorLanguageWidget extends StatelessWidget {
  final String sourceLang;
  final String targetLang;
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: Theme.of(context).primaryColorDark);

    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(DEFAULT_PADDING),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(sourceLang ?? "", style: textStyle),
          Icon(Icons.autorenew, color: Theme.of(context).primaryColorLight),
          Text(targetLang ?? "", style: textStyle)
        ]));
  }

  TranslatorLanguageWidget(this.sourceLang, this.targetLang);
}
