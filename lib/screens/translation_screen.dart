import 'dart:io' show File, Directory;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/sentence_model.dart';
import '../res/dimensions.dart';
import '../services/permission_service.dart';

class TranslationScreen extends StatefulWidget {
  Sentence sentence;
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
  String _targetLang = "francais";
  String _sourceLanguage = "english";
  String _appDirectory;
  String _recordedFilePath = "";
  Sentence _currentSentence;
  int _progression = 0;
  PageController _pageController;

  final Map<String, Color> _isRecordingColor = {
    "accent": Colors.red[600],
    "primaryLight": Colors.red[100],
    "primaryDark": Colors.red[800]
  };

  void _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this._author = prefs.getString("username");
      this._sourceLanguage = prefs.getString("sourceLanguage");
      this._targetLang = prefs.getString("targetLanguage");
      this._appDirectory = prefs.getString("appDirPath");
    });
  }

  Future<String> _createAudioRecordingFile(String filename) async {
    final Directory appDir = await getExternalStorageDirectory();
    final String filePath = appDir.path + "/$filename.$appFileExtension";
    File(filePath).createSync();
    return filePath;
  }

  void _startRecording() async {
    String filePath =
        await _createAudioRecordingFile("sentence${widget.sentence.id}");
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
                  color: _isRecordingColor["primaryDark"],
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

  Widget _buildRecorderWidget() {
    Widget stopIcon = Icon(Icons.stop,
        size: _recorderIconSize, color: _isRecordingColor["accent"]);
    Widget micIcon = Icon(Icons.mic,
        size: _recorderIconSize, color: Theme.of(context).accentColor);

    Color darkColor = Theme.of(context).primaryColorDark;
    Color lightColor = Theme.of(context).primaryColorLight;
    if (_isRecording) {
      darkColor = _isRecordingColor["primaryDark"];
      lightColor = _isRecordingColor["primaryLight"];
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
            padding: new EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
                border: new Border.all(color: darkColor, width: 1.0),
                borderRadius: new BorderRadius.circular(80.0),
                color: lightColor,
                boxShadow: [
                  new BoxShadow(color: darkColor, blurRadius: 20.0)
                ])));

    return recorder;
  }

  Widget _buildControlsWidget() {
    final textStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
        color: Theme.of(context).primaryColorDark);

    final controls = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: DEFAULT_PADDING, vertical: DEFAULT_PADDING / 2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_sourceLanguage ?? "", style: textStyle),
          _buildRecorderWidget(),
          Text(_targetLang ?? "", style: textStyle),
        ]));
    return Padding(padding: EdgeInsets.all(DEFAULT_PADDING), child: controls);
  }

  Widget _buildSentenceCard(Sentence phrase) {
    return Card(
        elevation: 1.0,
        child: Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(DEFAULT_PADDING),
            child: Center(
                child: Text(
              phrase.text,
              style: GoogleFonts.overlock(
                  textStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                      letterSpacing: 1.75,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold)),
            ))));
  }

  Widget _buildTimerWidget() {
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
        color: Color(0xFFF3F8F7),
        child: Column(children: [
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
                  child: FaIcon(FontAwesomeIcons.lightbulb)),
              Wrap(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: DEFAULT_PADDING),
                    child: Text(
                      "Tap on the microphone to record your translation of this sentence",
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(child: _buildSentenceCard(widget.sentence)),
          _buildTimerWidget(),
          _buildControlsWidget()
        ]));

    //return content;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            centerTitle: true,
            title: Text("Recorder"),
            elevation: 0,
            actions: [
              FlatButton.icon(
                  label: Text(""),
                  onPressed: () {
                    print("More button was pressed");
                  },
                  icon: Icon(Icons.more_vert, color: Colors.white))
            ]),
        body: content);
  }
}
