class Language {
  int id;
  String name;
  String type;
  String code;

  Language({this.id, this.name, this.type, this.code});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
        id: json['lang_id'],
        name: json['lang_name'],
        type: json['lang_type'],
        code: json['lang_code']);
  }

  static List<Language> asListFromJson(List<dynamic> json) {
    return json.map((i) => Language.fromJson(i)).toList();
  }

  Map<String, dynamic> toJson() =>
      {'lang_id': id, 'lang_name': name, 'lang_type': type, 'lang_code': code};
}
