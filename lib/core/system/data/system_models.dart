import 'package:JoDija_reposatory/utilis/models/base_data_model.dart';

class SystemInfo extends BaseEntityDataModel {
  final String appName;
  final String orgName;
  final String orgId;
  final String version;
  final bool isBootstrapped;
  final String defaultLanguage;
  final String licenseKey;
  final DateTime? licenseExpiryDate;
  final bool maintenanceMode;
  final String? logo;

  SystemInfo({
    required this.appName,
    required this.orgName,
    required this.orgId,
    required this.version,
    required this.isBootstrapped,
    required this.defaultLanguage,
    required this.licenseKey,
    this.licenseExpiryDate,
    this.maintenanceMode = false,
    this.logo,
  });

  factory SystemInfo.fromJson(Map<String, dynamic> json) {
    return SystemInfo(
      appName: json['appName'] ?? '',
      orgName: json['orgName'] ?? '',
      orgId: json['orgId'] ?? '',
      version: json['version'] ?? '1.0.0',
      isBootstrapped: json['isBootstrapped'] ?? false,
      defaultLanguage: json['defaultLanguage'] ?? 'ar',
      licenseKey: json['licenseKey'] ?? '',
      licenseExpiryDate: json['licenseExpiryDate'] != null
          ? DateTime.tryParse(json['licenseExpiryDate'].toString())
          : null,
      maintenanceMode: json['maintenanceMode'] ?? false,
      logo: json['logo'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'orgName': orgName,
      'orgId': orgId,
      'version': version,
      'isBootstrapped': isBootstrapped,
      'defaultLanguage': defaultLanguage,
      'licenseKey': licenseKey,
      'licenseExpiryDate': licenseExpiryDate?.toIso8601String(),
      'maintenanceMode': maintenanceMode,
      'logo': logo,
    };
  }
}

class BootstrapRequest extends BaseEntityDataModel {
  final String appName;
  final String organizationName;
  final String adminName;
  final String adminEmail;
  final String adminPassword;
  final String phone;
  final String defaultLanguage;
  final String licenseKey;
  final String? licenseExpiryDate;
  final String? logoPath;

  BootstrapRequest({
    required this.appName,
    required this.organizationName,
    required this.adminName,
    required this.adminEmail,
    required this.adminPassword,
    required this.phone,
    required this.defaultLanguage,
    required this.licenseKey,
    this.licenseExpiryDate,
    this.logoPath,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'organizationName': organizationName,
      'adminName': adminName,
      'adminEmail': adminEmail,
      'adminPassword': adminPassword,
      'phone': phone,
      'defaultLanguage': defaultLanguage,
      'licenseKey': licenseKey,
      'licenseExpiryDate': licenseExpiryDate,
      'logoPath': logoPath,
    };
  }
}
