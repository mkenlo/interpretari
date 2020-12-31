class Translation {
  int id;
  String author;

  String sentence;

  String targetLanguage;

  String audioFileName;

  String recordedOn;

  Translation(
      {this.id,
      this.author,
      this.sentence,
      this.targetLanguage,
      this.audioFileName,
      this.recordedOn});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
        id: json['translation_id'],
        author: json['author'],
        targetLanguage: json['target_lang'],
        sentence: json['sentence'],
        audioFileName: json['audiofile'] ?? "",
        recordedOn: json['recorded_on']);
  }

  static List<Translation> asListFromJson(List<dynamic> json) {
    return json.map((i) => Translation.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() => {
        'translation_id': id,
        'author': author,
        'sentence': sentence,
        'target_lang': targetLanguage,
        'audiofile': audioFileName,
        'recorded_on': recordedOn
      };
}
