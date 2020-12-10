import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/sentence_card_widget.dart';
import '../components/translator_language_widget.dart';
import '../config.dart';
import '../models/sentence_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/audio_service.dart';
import '../services/permission_service.dart';

class TranslationScreen extends StatefulWidget {
  final Sentence sentence;
  @override
  State createState() {
    return TranslationScreenState();
  }

  TranslationScreen({Key key, @required this.sentence}) : super(key: key);
}

class TranslationScreenState extends State<TranslationScreen> {
  String _recorderTimer;
  bool _isRecording = false;
  double _recorderIconSize = 60.0;
  FlutterSoundRecorder _flutterSound;
  String _author = dummyUserName;
  String _targetLang = "";
  String _sourceLanguage = "";
  String _recordedFilePath = "";

  void _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._author = prefs.getString("username");
      this._sourceLanguage = prefs.getString("sourceLanguage");
      this._targetLang = prefs.getString("targetLanguage");
    });
  }

  void _startRecording() async {
    String filePath =
        await createAudioRecordingFile("sentence${widget.sentence.id}");
    await _flutterSound.openAudioSession();
    await _flutterSound.startRecorder(toFile: filePath); // startRecorder

    _flutterSound.dispositionStream().listen((e) {
      if (e == null) {
        return;
      }
      DateTime date =
          new DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds);
      String txt = DateFormat('mm:ss:SS', 'en_US').format(date);

      setState(() {
        this._recordedFilePath = filePath;
        this._isRecording = true;
        this._recorderTimer = txt.substring(0, 8);
      });
    });
  }

  void _stopRecording() async {
    await _flutterSound.openAudioSession();
    _flutterSound
        .stopRecorder()
        .then((value) => setState(() {
              _isRecording = false;
            }))
        .catchError((error) => print(error));

    _askToSaveRecording();
  }

  void _doneRecording() {}

  void _cancelRecording({BuildContext context}) {
    final recordedFile = File(this._recordedFilePath);

    recordedFile.delete().then((result) {
      setState(() {
        _recorderTimer = "";
        _isRecording = false;
      });
    });
  }

  void _askToSaveRecording() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              title: Text("Save Recording"),
              content: Text("Are you satisfied with your recording?"),
              actions: <Widget>[
                FlatButton(
                  color: isRecordingColor["primaryDark"],
                  textColor: Colors.white,
                  child: Text('No'),
                  onPressed: () {
                    _cancelRecording(context: context);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Colors.white,
                  child: Text('Yes'),
                  onPressed: () {
                    _doneRecording();
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
  }

  Widget recorderWidget() {
    Widget stopIcon = Icon(Icons.stop,
        size: _recorderIconSize, color: isRecordingColor["accent"]);
    Widget micIcon = Icon(Icons.mic,
        size: _recorderIconSize, color: Theme.of(context).accentColor);

    Color darkColor = Theme.of(context).primaryColorDark;
    Color lightColor = Theme.of(context).primaryColorLight;
    if (_isRecording) {
      darkColor = isRecordingColor["primaryDark"];
      lightColor = isRecordingColor["primaryLight"];
    }

    Widget recorder = GestureDetector(
        onTap: () {
          Permission.microphone.request().isGranted.then((permission) {
            if (permission)
              (_isRecording) ? _stopRecording() : _startRecording();
            else
              requestAppPermission();
          });
        },
        child: Container(
            child: _flutterSound.isRecording ? stopIcon : micIcon,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: darkColor, width: 1.0),
                borderRadius: BorderRadius.circular(80.0),
                color: lightColor,
                boxShadow: [
                  new BoxShadow(color: darkColor, blurRadius: 20.0)
                ])));

    return recorder;
  }

  Widget timerWidget() {
    return Padding(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Text("$_recorderTimer", style: TextStyle(fontSize: 30.0)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_flutterSound != null) {
      _flutterSound.closeAudioSession();
    }
  }

  @override
  void initState() {
    super.initState();
    _recorderTimer = "";
    _isRecording = false;
    _flutterSound = new FlutterSoundRecorder();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
        padding: EdgeInsets.all(DEFAULT_PADDING),
        color: bgPrimaryColor,
        child: Column(children: [
          TranslatorLanguageWidget(_sourceLanguage, _targetLang),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.lightbulb),
              title: Text(LABEL_RECORDING_INSTRUCTIONS,
                  style: Theme.of(context).textTheme.caption),
              contentPadding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING)),
          SentenceCardWidget(widget.sentence),
          timerWidget(),
          recorderWidget(),
        ]));

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(TITLE_RECORDER_APPBAR),
            elevation: 1.0),
        body: content);
  }
}
