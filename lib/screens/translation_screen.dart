import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart';

import '../components/sentence_card_widget.dart';
import '../components/translator_language_widget.dart';
import '../models/sentence_model.dart';
import '../models/translation_model.dart';
import '../models/user_model.dart';
import '../res/colors.dart';
import '../res/dimensions.dart';
import '../res/strings.dart';
import '../services/audio_service.dart';
import '../services/language_service.dart';
import '../services/permission_service.dart';
import '../services/translation_service.dart';
import '../services/user_service.dart';

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
  String _targetLang = "";
  String _sourceLanguage = "";
  String _recordedFilePath = "";

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

  void _doneRecording() async {
    Translation translation = await saveTranslation(Translation(
        sentence: widget.sentence.id.toString(),
        audioFileName: "sentence${widget.sentence.id}"));
    String filePath = await getAudioFullPath("sentence${widget.sentence.id}");
    await uploadTranslationFile(translation.id, filePath);

    final snackBar = SnackBar(
      content: Text('Yay! Your recording was saved!'),
      action: SnackBarAction(
        label: 'Done',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                    }),
                FlatButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      _doneRecording();
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _askUserToLogin() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              titleTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              title: Text("Time to Login!"),
              content: Text(
                  "Create a profile or Login to record and save a translation."),
              actions: <Widget>[
                FlatButton(
                    color: isRecordingColor["primaryDark"],
                    textColor: Colors.white,
                    child: Text('Later'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Colors.white,
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(ROUTE_SIGNIN);
                    })
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
        onTap: () async {
          User user = await UserService().getProfileInfoFromPreferences();
          if (user == null) {
            _askUserToLogin();
          } else {
            Permission.microphone.request().isGranted.then((permission) {
              if (permission)
                (_isRecording) ? _stopRecording() : _startRecording();
              else
                requestAppPermission();
            });
          }
        },
        child: Container(
            child: _flutterSound.isRecording ? stopIcon : micIcon,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: darkColor, width: 1.0),
                borderRadius: BorderRadius.circular(80.0),
                color: lightColor,
                boxShadow: [BoxShadow(color: darkColor, blurRadius: 20.0)])));

    return recorder;
  }

  Widget timerWidget() {
    return Padding(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: Text("$_recorderTimer", style: TextStyle(fontSize: 30.0)));
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
    getPreferredLanguage().then((languages) {
      setState(() {
        this._sourceLanguage = languages[0].name;
        this._targetLang = languages[1].name;
      });
    });
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
