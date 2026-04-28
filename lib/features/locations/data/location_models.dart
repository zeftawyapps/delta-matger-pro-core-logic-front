class Country {
  final String id;
  final Name name;
  final String currency;
  final String phoneCode;
  final bool isActive;

  Country({
    required this.id,
    required this.name,
    this.currency = '',
    this.phoneCode = '',
    this.isActive = true,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: json['name'] != null ? Name.fromJson(json['name']) : Name(ar: '', en: ''),
      currency: json['currency']?.toString() ?? '',
      phoneCode: json['phoneCode']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'currency': currency,
      'phoneCode': phoneCode,
      'isActive': isActive,
    };
  }
}

class Governorate {
  final String id;
  final String countryId;
  final Name name;
  final String? code;
  final double defaultShippingFee;
  final bool isActive;

  Governorate({
    required this.id,
    required this.countryId,
    required this.name,
    this.code,
    this.defaultShippingFee = 0.0,
    this.isActive = true,
  });

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      countryId: (json['countryId'] ?? '').toString(),
      name: json['name'] != null ? Name.fromJson(json['name']) : Name(ar: '', en: ''),
      code: json['code']?.toString(),
      defaultShippingFee: (json['defaultShippingFee'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countryId': countryId,
      'name': name.toJson(),
      'code': code,
      'defaultShippingFee': defaultShippingFee,
      'isActive': isActive,
    };
  }
}

class Name {
  final String ar;
  final String en;

  Name({required this.ar, required this.en});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'ar': ar, 'en': en};

  // دالة مساعدة لجلب الاسم بناءً على لغة التطبيق
  String get(String langCode) => langCode == 'ar' ? ar : en;
}

class City {
  final String id;
  final String governorateId;
  final Name name;
  final double? defaultShippingFee;
  final bool isActive;

  City({
    required this.id,
    required this.governorateId,
    required this.name,
    this.defaultShippingFee,
    this.isActive = true,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      governorateId: (json['governorateId'] ?? '').toString(),
      name: json['name'] != null ? Name.fromJson(json['name']) : Name(ar: '', en: ''),
      defaultShippingFee: (json['defaultShippingFee'])?.toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'governorateId': governorateId,
      'name': name.toJson(),
      'defaultShippingFee': defaultShippingFee,
      'isActive': isActive,
    };
  }
}
