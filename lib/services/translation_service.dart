import "dart:async";
import "dart:convert";
import 'dart:io' show File;

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../models/translation_model.dart';

const url = '$apiAuthorityUrl/translations';

Future<dynamic> fetchTranslation(int userId) async {
  final response =
      await http.get('$apiAuthorityUrl/translations?author=$userId');

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Translation.asListFromJson(jsonResponse);
  } else {
    throw Exception('Failed to load Data');
  }
}

Future<int> saveTranslation(Translation translation, String fileContent) async {
  final response = await http.post(url,
      body: json.encode({
        "author": translation.author.id,
        "sentence": translation.sentence.id,
        "target_lang": translation.targetLanguage.id
      }));

  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    return result.id;
  } else
    throw Exception("Error while saving the object");
}

Future<int> uploadTranslationFile(int translationId, String filePath) async {
  http.MultipartRequest request = http.MultipartRequest(
      'post', Uri.parse("$url/$translationId/upload-audio"));
  final uploadFile = await http.MultipartFile.fromPath('audiofile', filePath);
  request.files.add(uploadFile);
  final response = await request.send();
  return response.statusCode;
}

Future readFileContentAndUploadTranslation(Translation translation) async {
  String fileContents = "";
  final appFilePath = await getExternalStorageDirectory();

  File file = File("${appFilePath.path}/${translation.audioFileName}");

  if (await file.exists()) {
    var stream = file.openRead();

    return stream.transform(base64.encoder).listen((data) {
      if (data == null) {
        return;
      }
      fileContents = fileContents + data;
    }, onError: (e) {
      throw Exception(e);
    }, onDone: () {
      saveTranslation(translation, fileContents).catchError((err) {
        // TODO : find a way to properly propagate error to the widget
        print(err); // Intentionally left
      });
    });
  } else {
    throw Exception("Missing File");
  }
}
