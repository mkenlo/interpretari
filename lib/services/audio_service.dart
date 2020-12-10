import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

const String APP_FILE_EXTENSION = "m4a";

Future<String> createAudioRecordingFile(String filename) async {
  final Directory appDir = await getExternalStorageDirectory();
  final String filePath = appDir.path + "/$filename.$APP_FILE_EXTENSION";
  File(filePath).createSync();
  return filePath;
}

Future<String> getAudioFullPath(String filename) async {
  final Directory appDir = await getExternalStorageDirectory();
  return appDir.path + "/$filename.$APP_FILE_EXTENSION";
}
