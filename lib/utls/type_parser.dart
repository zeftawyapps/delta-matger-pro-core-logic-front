class TypeParser {
  static double parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) {
      if (value.isEmpty || value == 'null') return defaultValue;
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  static int parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is num) return value.toInt();
    if (value is String) {
      if (value.isEmpty || value == 'null') return defaultValue;
      return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? defaultValue;
    }
    return defaultValue;
  }

  static bool parseBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final v = value.toLowerCase().trim();
      if (v == 'true' || v == '1' || v == 'yes' || v == 'on' || v == 'active')
        return true;
      if (v == 'false' || v == '0' || v == 'no' || v == 'off' || v == 'inactive')
        return false;
    }
    return defaultValue;
  }
}

extension DynamicParserExt on Object? {
  double toDoubleValue([double defaultValue = 0.0]) =>
      TypeParser.parseDouble(this, defaultValue);
  int toIntValue([int defaultValue = 0]) =>
      TypeParser.parseInt(this, defaultValue);
  bool toBoolValue([bool defaultValue = false]) =>
      TypeParser.parseBool(this, defaultValue);
}
