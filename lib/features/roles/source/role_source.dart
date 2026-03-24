import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';

class RoleSource {
  RoleSource();

  // ─── Permissions ──────────────────────────────────────────────────────────

  /// جلب جميع الصلاحيات المتاحة في النظام.
  /// يُستخدم لعرض قائمة الصلاحيات عند إنشاء أو تعديل دور.
  Future<Result<RemoteBaseModel, dynamic>> getAllPermissions() async {
    try {
      JDRepoConsole.info(
        'Fetching all permissions',
        context: LogContext(module: 'RoleSource', method: 'getAllPermissions'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.allPermissions}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getAllPermissions', e);
    }
  }

  /// فحص ما إذا كان المستخدم يملك صلاحية معينة.
  Future<Result<RemoteBaseModel, dynamic>> checkPermission({
    required List<String> userRoles,
    required String permissionType,
    required String resource,
  }) async {
    try {
      JDRepoConsole.info(
        'Checking permission: $resource:$permissionType',
        context: LogContext(module: 'RoleSource', method: 'checkPermission'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.checkPermission}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {
          'userRoles': userRoles,
          'permissionType': permissionType,
          'resource': resource,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('checkPermission', e);
    }
  }

  // ─── Roles CRUD ───────────────────────────────────────────────────────────

  /// جلب قائمة الأدوار. يمكن تصفيتها بـ [organizationId].
  Future<Result<RemoteBaseModel, dynamic>> getRoles({
    String? organizationId,
  }) async {
    try {
      JDRepoConsole.info(
        'Fetching roles${organizationId != null ? ' for org: $organizationId' : ''}',
        context: LogContext(module: 'RoleSource', method: 'getRoles'),
      );
      String url = '${ApiUrls.BASE_URL}${EndPoints.roles}';
      if (organizationId != null) url += '?organizationId=$organizationId';

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getRoles', e);
    }
  }

  /// إنشاء دور جديد.
  Future<Result<RemoteBaseModel, dynamic>> createRole({
    required String name,
    String? displayName,
    String? description,
    required List<String> permissions,
    String? organizationId,
  }) async {
    try {
      JDRepoConsole.info(
        'Creating role: $name',
        context: LogContext(module: 'RoleSource', method: 'createRole'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.roles}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {
          'name': name,
          if (displayName != null) 'displayName': displayName,
          if (description != null) 'description': description,
          'permissions': permissions,
          if (organizationId != null) 'organizationId': organizationId,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('createRole', e);
    }
  }

  /// جلب بيانات دور واحد بالـ ID.
  Future<Result<RemoteBaseModel, dynamic>> getRoleById(String roleId) async {
    try {
      JDRepoConsole.info(
        'Fetching role by id: $roleId',
        context: LogContext(module: 'RoleSource', method: 'getRoleById'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.roleById(roleId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getRoleById', e);
    }
  }

  /// تعديل دور موجود.
  Future<Result<RemoteBaseModel, dynamic>> updateRole({
    required String roleId,
    String? name,
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      JDRepoConsole.info(
        'Updating role: $roleId',
        context: LogContext(module: 'RoleSource', method: 'updateRole'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.roleById(roleId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {
          if (name != null) 'name': name,
          if (displayName != null) 'displayName': displayName,
          if (description != null) 'description': description,
          if (permissions != null) 'permissions': permissions,
          if (isActive != null) 'isActive': isActive,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('updateRole', e);
    }
  }

  /// حذف دور (Soft Delete).
  Future<Result<RemoteBaseModel, dynamic>> deleteRole(String roleId) async {
    try {
      JDRepoConsole.info(
        'Deleting role: $roleId',
        context: LogContext(module: 'RoleSource', method: 'deleteRole'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.roleById(roleId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('deleteRole', e);
    }
  }

  /// نسخ دور موجود لمنظمة أخرى.
  Future<Result<RemoteBaseModel, dynamic>> copyRole({
    required String roleId,
    required String targetOrganizationId,
  }) async {
    try {
      JDRepoConsole.info(
        'Copying role $roleId to org: $targetOrganizationId',
        context: LogContext(module: 'RoleSource', method: 'copyRole'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.copyRole(roleId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {'targetOrganizationId': targetOrganizationId},
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('copyRole', e);
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Result<RemoteBaseModel, dynamic> _wrap(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }
    return Result.error(
      RemoteBaseModel(
        message: result.error?.message ?? result.data?.message,
        status: result.data?.status ?? StatusModel.error,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      'Error in $method: $e',
      context: LogContext(module: 'RoleSource', method: method),
    );
    return Result.error(
      RemoteBaseModel(message: e.toString(), status: StatusModel.error),
    );
  }
}
