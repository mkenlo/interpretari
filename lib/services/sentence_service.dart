import "dart:async";
import "dart:convert" show json;

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/sentence_model.dart';

const url = '$apiAuthorityUrl/sentences';

Future<List<Sentence>> fetchSentences(String filter) async {
  final response = await http.get('$url?$filter');

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return Sentence.asListFromJson(jsonResponse);
  } else {
    throw Exception('Failed to load Data');
  }
}
