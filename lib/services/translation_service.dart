import "dart:async";
import "dart:convert";

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/language_model.dart';
import '../models/translation_model.dart';
import '../models/user_model.dart';
import 'language_service.dart';
import 'user_service.dart';

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

Future<Translation> saveTranslation(Translation translation) async {
  User currentUser = await UserService().getProfileInfoFromPreferences();
  Language targetLang = (await getPreferredLanguage()).last;
  final response = await http.post(url,
      body: json.encode({
        "author": currentUser.id,
        "sentence": translation.sentence,
        "target_lang": targetLang.id
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

  if (response.statusCode == 201) {
    return Translation.fromJson(json.decode(response.body));
  } else
    throw Exception("Error while saving the object");
}

Future<int> uploadTranslationFile(int translationId, String filePath) async {
  http.MultipartRequest request =
      http.MultipartRequest('post', Uri.parse("$url/$translationId/upload"));
  final uploadFile = await http.MultipartFile.fromPath('audiofile', filePath);
  request.files.add(uploadFile);
  final response = await request.send();
  return response.statusCode;
}
