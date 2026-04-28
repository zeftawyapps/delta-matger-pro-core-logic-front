import 'package:matger_pro_core_logic/models/entity_meta.dart';
import 'permission_model.dart';

class RoleModel {
  final String id;
  final String name;
  final String? description;
  final List<PermissionModel> permissions;
  final bool isActive;
  final EntityMeta? meta;

  RoleModel({
    required this.id,
    required this.name,
    this.description,
    this.permissions = const [],
    this.isActive = true,
    this.meta,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    var permissionList = json['permissions'] as List? ?? [];
    List<PermissionModel> parsedPermissions = [];

    for (var p in permissionList) {
      if (p is Map<String, dynamic>) {
        parsedPermissions.add(PermissionModel.fromJson(p));
      } else if (p is String) {
        // If it's just a string key, we might need a way to hydrate it,
        // but for now we create a basic model or skip.
        // In the TS code, it sometimes uses permission strings like "user:read".
      }
    }

    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      permissions: parsedPermissions,
      isActive: json['isActive'] as bool? ?? true,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions.map((p) => p.toJson()).toList(),
      'isActive': isActive,
      'meta': meta?.toJson(),
    };
  }

  bool hasPermission(PermissionType type, ResourceType resource) {
    if (!isActive) return false;
    return permissions.any(
      (p) =>
          p.isActive &&
          p.type == type &&
          (p.resource == resource || p.resource == ResourceType.all),
    );
  }
}
