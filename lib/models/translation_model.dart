import 'language_model.dart';
import 'sentence_model.dart';
import 'user_model.dart';

class Translation {
  User author;

  Sentence sentence;

  Language targetLanguage;

  String audioFileName;

  String recordedOn;

  Translation(
      {this.author,
      this.sentence,
      this.targetLanguage,
      this.audioFileName,
      this.recordedOn});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
        author: User.fromJson(json['author']),
        targetLanguage: Language.fromJson(json['target_lang']),
        sentence: Sentence.fromJson(json['sentence']),
        audioFileName: json['audiofile'],
        recordedOn: json['recorded_on']);
  }

  static List<Translation> asListFromJson(List<dynamic> json) {
    return json.map((i) => Translation.fromJson(i)).toList();
  }
}
