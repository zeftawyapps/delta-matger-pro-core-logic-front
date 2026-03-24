import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_core_logic/core/auth/data/permission_model.dart';
import 'package:matger_core_logic/features/roles/data/role_data_model.dart';
import 'package:matger_core_logic/features/roles/source/role_source.dart';

class RoleRepo {
  late final RoleSource _roleSource;

  RoleRepo({RoleSource? roleSource}) {
    _roleSource = roleSource ?? RoleSource();
  }

  // ─── Permissions ──────────────────────────────────────────────────────────

  /// جلب جميع الصلاحيات المتاحة في النظام.
  /// مناسب لعرضها كـ Checkboxes عند إنشاء أو تعديل دور.
  Future<RemoteBaseModel<List<PermissionModel>>> getAllPermissions() async {
    JDRepoConsole.info(
      'Fetching all permissions in repo',
      context: LogContext(module: 'RoleRepo', method: 'getAllPermissions'),
    );
    final result = await _roleSource.getAllPermissions();

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getAllPermissions: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'getAllPermissions'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else {
        rawList = [];
      }

      final permissions = rawList
          .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        'Fetched ${permissions.length} permissions successfully',
        context: LogContext(module: 'RoleRepo', method: 'getAllPermissions'),
      );
      return RemoteBaseModel(data: permissions, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in getAllPermissions: $e',
        context: LogContext(
          module: 'RoleRepo',
          method: 'getAllPermissions',
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }

  /// فحص ما إذا كان المستخدم يملك صلاحية معينة.
  Future<RemoteBaseModel<PermissionCheckResult>> checkPermission({
    required List<String> userRoles,
    required String permissionType,
    required String resource,
  }) async {
    JDRepoConsole.info(
      'Checking permission $resource:$permissionType in repo',
      context: LogContext(module: 'RoleRepo', method: 'checkPermission'),
    );
    final result = await _roleSource.checkPermission(
      userRoles: userRoles,
      permissionType: permissionType,
      resource: resource,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in checkPermission: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'checkPermission'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final raw = result.data is Map
          ? result.data as Map<String, dynamic>
          : <String, dynamic>{};
      final checkResult = PermissionCheckResult.fromJson(raw);
      JDRepoConsole.success(
        'Permission check result: ${checkResult.hasPermission}',
        context: LogContext(module: 'RoleRepo', method: 'checkPermission'),
      );
      return RemoteBaseModel(data: checkResult, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in checkPermission: $e',
        context: LogContext(
          module: 'RoleRepo',
          method: 'checkPermission',
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }

  // ─── Roles CRUD ───────────────────────────────────────────────────────────

  /// جلب قائمة الأدوار. يمكن تصفيتها بـ [organizationId].
  Future<RemoteBaseModel<List<RoleDataModel>>> getRoles({
    String? organizationId,
  }) async {
    JDRepoConsole.info(
      'Getting roles in repo',
      context: LogContext(module: 'RoleRepo', method: 'getRoles'),
    );
    final result = await _roleSource.getRoles(organizationId: organizationId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getRoles: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'getRoles'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseList(result.data, 'getRoles');
  }

  /// إنشاء دور جديد.
  Future<RemoteBaseModel<RoleDataModel>> createRole({
    required String name,
    String? displayName,
    String? description,
    required List<String> permissions,
    String? organizationId,
  }) async {
    JDRepoConsole.info(
      'Creating role in repo: $name',
      context: LogContext(module: 'RoleRepo', method: 'createRole'),
    );
    final result = await _roleSource.createRole(
      name: name,
      displayName: displayName,
      description: description,
      permissions: permissions,
      organizationId: organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in createRole: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'createRole'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'createRole');
  }

  /// جلب بيانات دور واحد بالـ ID.
  Future<RemoteBaseModel<RoleDataModel>> getRoleById(String roleId) async {
    JDRepoConsole.info(
      'Getting role by id in repo: $roleId',
      context: LogContext(module: 'RoleRepo', method: 'getRoleById'),
    );
    final result = await _roleSource.getRoleById(roleId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getRoleById: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'getRoleById'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'getRoleById');
  }

  /// تعديل دور موجود.
  Future<RemoteBaseModel<RoleDataModel>> updateRole({
    required String roleId,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    JDRepoConsole.info(
      'Updating role in repo: $roleId',
      context: LogContext(module: 'RoleRepo', method: 'updateRole'),
    );
    final result = await _roleSource.updateRole(
      roleId: roleId,
      name: name,
      displayName: displayName,
      description: description,
      permissions: permissions,
      isActive: isActive,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in updateRole: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'updateRole'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'updateRole');
  }

  /// حذف دور (Soft Delete).
  Future<RemoteBaseModel<bool>> deleteRole(String roleId) async {
    JDRepoConsole.info(
      'Deleting role in repo: $roleId',
      context: LogContext(module: 'RoleRepo', method: 'deleteRole'),
    );
    final result = await _roleSource.deleteRole(roleId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in deleteRole: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'deleteRole'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      'Role deleted successfully in repo',
      context: LogContext(module: 'RoleRepo', method: 'deleteRole'),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  /// نسخ دور موجود لمنظمة أخرى.
  Future<RemoteBaseModel<RoleDataModel>> copyRole({
    required String roleId,
    required String targetOrganizationId,
  }) async {
    JDRepoConsole.info(
      'Copying role in repo: $roleId',
      context: LogContext(module: 'RoleRepo', method: 'copyRole'),
    );
    final result = await _roleSource.copyRole(
      roleId: roleId,
      targetOrganizationId: targetOrganizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in copyRole: ${result.error?.message}',
        context: LogContext(module: 'RoleRepo', method: 'copyRole'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'copyRole');
  }

  // ─── Parsing Helpers ──────────────────────────────────────────────────────

  RemoteBaseModel<RoleDataModel> _parseSingle(dynamic data, String method) {
    try {
      final raw = data is Map
          ? data as Map<String, dynamic>
          : (data is Map && data['data'] is Map)
              ? data['data'] as Map<String, dynamic>
              : <String, dynamic>{};
      final role = RoleDataModel.fromJson(raw);
      JDRepoConsole.success(
        'Role parsed successfully in repo ($method)',
        context: LogContext(module: 'RoleRepo', method: method),
      );
      return RemoteBaseModel(data: role, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in $method: $e',
        context: LogContext(module: 'RoleRepo', method: method, metadata: data),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }

  RemoteBaseModel<List<RoleDataModel>> _parseList(
    dynamic data,
    String method,
  ) {
    try {
      final List rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map && data['data'] is List) {
        rawList = data['data'];
      } else {
        rawList = [];
      }

      final roles = rawList
          .map((e) => RoleDataModel.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        'Fetched ${roles.length} roles successfully ($method)',
        context: LogContext(module: 'RoleRepo', method: method),
      );
      return RemoteBaseModel(data: roles, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in $method: $e',
        context: LogContext(module: 'RoleRepo', method: method, metadata: data),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }
}
