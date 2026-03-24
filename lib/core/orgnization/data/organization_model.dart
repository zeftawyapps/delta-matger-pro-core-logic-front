import 'package:matger_core_logic/models/entity_meta.dart';

class OrganizationData {
  final String organizationId;
  final String name;
  final String ownerId;
  final String address;
  final String phone;
  final String email;
  final LocationData? location;
  final bool isActive;
  final bool isDataComplete;
  final EntityMeta? meta;

  OrganizationData({
    required this.organizationId,
    required this.name,
    required this.ownerId,
    required this.address,
    required this.phone,
    required this.email,
    this.location,
    this.isActive = true,
    this.isDataComplete = false,
    this.meta,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    return OrganizationData(
      organizationId: (json['organizationId'] ?? json['_id']) as String? ?? '',
      name: (json['name'] ?? json['orgName']) as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      location: json['location'] != null && json['location'] is Map
          ? LocationData.fromJson(Map<String, dynamic>.from(json['location']))
          : null,
      isActive: json['isActive'] as bool? ?? true,
      isDataComplete: json['isDataComplete'] as bool? ?? false,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'name': name,
      'ownerId': ownerId,
      'address': address,
      'phone': phone,
      'email': email,
      'location': location?.toJson(),
      'isActive': isActive,
      'isDataComplete': isDataComplete,
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
