import 'package:matger_core_logic/models/entity_meta.dart';

enum PermissionType {
  read,
  add,
  update,
  delete,
  manage,
  stream,
  admin,
  workflowAction,
  view,
  all; // Represents '*'

  static PermissionType fromString(String value) {
    if (value == '*') return PermissionType.all;
    return PermissionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PermissionType.read,
    );
  }

  String toRawString() {
    if (this == PermissionType.all) return '*';
    return name;
  }
}

enum ResourceType {
  controlPanel,
  superAdmin,
  commerce,
  user,
  role,
  permission,
  system,
  dashboard,
  reports,
  users,
  settings,
  orders,
  products,
  product,
  category,
  order,
  organization,
  offer,
  orgnizationownerData,
  all; // Represents '*'

  static ResourceType fromString(String value) {
    if (value == '*') return ResourceType.all;
    
    // Handle screen. prefix
    String cleanValue = value;
    if (value.startsWith('screen.')) {
      cleanValue = value.replaceFirst('screen.', '');
    }

    return ResourceType.values.firstWhere(
      (e) => e.name == cleanValue,
      orElse: () => ResourceType.all,
    );
  }

  String toRawString() {
    if (this == ResourceType.all) return '*';
    
    // Check if it's a screen resource
    const screens = ['dashboard', 'reports', 'users', 'settings', 'orders', 'products'];
    if (screens.contains(name)) {
      return 'screen.$name';
    }
    
    return name;
  }
}


class PermissionModel {
  final String id;
  final String name;
  final String? description;
  final PermissionType type;
  final ResourceType resource;
  final Map<String, dynamic>? conditions;
  final bool isActive;
  final EntityMeta? meta;

  PermissionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.resource,
    this.description,
    this.conditions,
    this.isActive = true,
    this.meta,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      type: PermissionType.fromString(json['type'] as String? ?? 'read'),
      resource: ResourceType.fromString(json['resource'] as String? ?? '*'),
      conditions: json['conditions'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'resource': resource.toRawString(),
      'conditions': conditions,
      'isActive': isActive,
      'meta': meta?.toJson(),
    };
  }

  String get permissionKey => "${resource.toRawString()}:${type.name}";
}
