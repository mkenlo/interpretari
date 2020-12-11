import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/sentence_model.dart';
import '../res/dimensions.dart';

class SentenceCardWidget extends StatelessWidget {
  final Sentence sentence;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: SizedBox(
            height: 200.0,
            child: Container(
                padding: EdgeInsets.all(DEFAULT_PADDING),
                child: Center(
                    child: Text(sentence.text,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0))))));
  }

  SentenceCardWidget(this.sentence);
}
