class Language {
  int id;
  String name;
  String type;
  String code;

  Language(this.id, this.name, this.type, this.code);
  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(json['lang_id'], json['lang_name'], json['lang_type'],
        json['lang_code']);
  }

  static List<Language> asListFromJson(List<dynamic> json) {
    return json.map((i) => Language.fromJson(i)).toList();
  }
}
