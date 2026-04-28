import 'package:matger_pro_core_logic/models/entity_meta.dart';

/// نموذج الدور الكامل المستخدم في شاشات إدارة الأدوار.
/// يختلف عن [RoleModel] في core/auth/data بأنه:
/// - يحتوي على [displayName] لعرض اسم الدور في الواجهة.
/// - يخزّن الصلاحيات كـ [List<String>] (مثل "product:*") تماشياً مع الـ API.
/// - يدعم [organizationId] لربط الدور بمنظمة.
class RoleDataModel {
  final String? id;
  final String name;
  final String? displayName;
  final String? description;
  final List<String> permissions;
  final bool isActive;
  final String? organizationId;
  final EntityMeta? meta;

  RoleDataModel({
    this.id,
    required this.name,
    this.displayName,
    this.description,
    this.permissions = const [],
    this.isActive = true,
    this.organizationId,
    this.meta,
  });

  factory RoleDataModel.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'] as List? ?? [];
    final parsedPermissions = rawPermissions
        .map((e) => e is Map ? '${e['resource']}:${e['type']}' : e.toString())
        .toList();

    return RoleDataModel(
      id: json['id'] as String? ?? json['_id'] as String?,
      name: json['name'] as String? ?? '',
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      permissions: List<String>.from(parsedPermissions),
      isActive: json['isActive'] as bool? ?? true,
      organizationId: json['organizationId'] as String?,
      meta: json['meta'] != null
          ? EntityMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (displayName != null) 'displayName': displayName,
      if (description != null) 'description': description,
      'permissions': permissions,
      'isActive': isActive,
      if (organizationId != null) 'organizationId': organizationId,
      'meta': meta?.toJson(),
    };
  }

  RoleDataModel copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? isActive,
    String? organizationId,
    EntityMeta? meta,
  }) {
    return RoleDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      organizationId: organizationId ?? this.organizationId,
      meta: meta ?? this.meta,
    );
  }

  @override
  String toString() =>
      'RoleDataModel(id: $id, name: $name, displayName: $displayName, '
      'isActive: $isActive, permissions: ${permissions.length})';
}

/// نتيجة فحص الصلاحية لمستخدم معين.
class PermissionCheckResult {
  final bool hasPermission;
  final String? message;

  PermissionCheckResult({required this.hasPermission, this.message});

  factory PermissionCheckResult.fromJson(Map<String, dynamic> json) {
    return PermissionCheckResult(
      hasPermission: json['hasPermission'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
