import 'package:JoDija_reposatory/utilis/models/base_data_model.dart';

class Language extends BaseEntityDataModel {
  final String code;
  final String name;
  final String nativeName;
  final bool isDefault;
  final bool isActive;
  final String direction; // 'ltr' or 'rtl'
  final DateTime? createdAt;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isDefault = false,
    this.isActive = true,
    this.direction = 'ltr',
    this.createdAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nativeName: json['nativeName'] ?? '',
      isDefault: json['isDefault'] ?? false,
      isActive: json['isActive'] ?? true,
      direction: json['direction'] ?? 'ltr',
      createdAt: json['meta'] != null && json['meta']['createdAt'] != null
          ? DateTime.tryParse(json['meta']['createdAt'].toString())
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'nativeName': nativeName,
      'isDefault': isDefault,
      'isActive': isActive,
      'direction': direction,
      'meta': {
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      },
    };
  }
}
