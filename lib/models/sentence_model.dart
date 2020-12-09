class Sentence {
  int id;
  String text;
  String language;

  Sentence(this.id, this.text, this.language);

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
        json['sentence_id'], json['sentence_text'], json['sentence_lang']);
  }

  static List<Sentence> asListFromJson(List<dynamic> json) {
    return json.map((i) => Sentence.fromJson(i)).toList();
  }
}
