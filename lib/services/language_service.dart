import "dart:async";
import "dart:convert";

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/language_model.dart';

const url = '$apiAuthorityUrl/languages';

Future<List<Language>> fetchLanguages(String filter) async {
  final response = await http.get('$url?$filter');

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Language.asListFromJson(jsonResponse);
  } else {
    throw Exception('Failed to load Data');
  }
}

Future<List> getPreferredLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return [
    Language.fromJson(json.decode(prefs.getString("sourceLanguage"))),
    Language.fromJson(json.decode(prefs.getString("targetLanguage")))
  ];
}

Future<List> filterLanguagesByType() async {
  List languages = await fetchLanguages("");
  List<Language> sources = [];
  List<Language> targets = [];
  languages.forEach((element) {
    if (element.type == "local") {
      targets.add(element);
    } else
      sources.add(element);
  });
  return [sources, targets];
}
