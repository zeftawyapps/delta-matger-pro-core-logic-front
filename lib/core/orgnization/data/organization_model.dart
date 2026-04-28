import 'package:matger_pro_core_logic/models/entity_meta.dart';

class OrganizationData {
  final String id;
  final String orgName; // brand-slug
  final String name; // الاسم الكامل
  final String ownerId;
  final String address;
  final String phone;
  final String email;
  final String? countryId;
  final String? governorateId;
  final String? cityId;
  final LocationData? location;
  final bool isActive;
  final bool isDataComplete;
  final bool isTemplate;
  final EntityMeta? meta;

  OrganizationData({
    required this.id,
    required this.orgName,
    required this.name,
    required this.ownerId,
    required this.address,
    required this.phone,
    required this.email,
    this.countryId,
    this.governorateId,
    this.cityId,
    this.location,
    this.isActive = true,
    this.isDataComplete = false,
    this.isTemplate = false,
    this.meta,
  });

  // Aliases for backward compatibility if needed
  String get organizationId => id;

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    return OrganizationData(
      id: (json['id'] ?? json['organizationId'] ?? json['_id'] ?? '')
          .toString(),
      orgName: (json['orgName'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      ownerId: (json['ownerId'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      countryId: json['countryId']?.toString(),
      governorateId: json['governorateId']?.toString(),
      cityId: json['cityId']?.toString(),
      location: json['location'] != null && json['location'] is Map
          ? LocationData.fromJson(Map<String, dynamic>.from(json['location']))
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isDataComplete: json['isDataComplete'] as bool? ?? false,
      isTemplate: json['isTemplate'] as bool? ?? false,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orgName': orgName,
      'name': name,
      'ownerId': ownerId,
      'address': address,
      'phone': phone,
      'email': email,
      'countryId': countryId,
      'governorateId': governorateId,
      'cityId': cityId,
      'location': location?.toJson(),
      'isActive': isActive,
      'isDataComplete': isDataComplete,
      'isTemplate': isTemplate,
      'meta': meta?.toJson(),
    };
  }
}

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({required this.latitude, required this.longitude});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}
