class LocalizedString {
  final Map<String, String> values;

  LocalizedString(this.values);

  factory LocalizedString.fromJson(dynamic json) {
    if (json is String) return LocalizedString({'ar': json, 'en': json});
    if (json is Map) {
      return LocalizedString(Map<String, String>.from(json));
    }
    return LocalizedString({'ar': '', 'en': ''});
  }

  String get(String lang) => values[lang] ?? values['ar'] ?? values['en'] ?? '';

  String get ar => get('ar');
  String get en => get('en');

  Map<String, dynamic> toJson() => values;
}
