import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';

class UserSource {
  UserSource();

  // ─── Create ───────────────────────────────────────────────────────────────

  /// إنشاء مستخدم أو موظف جديد وربطه بأدوار مخصصة.
  /// لا يسمح بتعيين أدوار النظام الأساسية (admin, customer, driver).
  Future<Result<RemoteBaseModel, dynamic>> createNewUser({
    required String username,
    required String email,
    required String password,
    required String phone,
    List<String> roles = const [],
    String? address,
    String? organizationId,
  }) async {
    try {
      JDRepoConsole.info(
        'Creating new user: $username',
        context: LogContext(module: 'UserSource', method: 'createNewUser'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.createNewUser}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
          if (roles.isNotEmpty) 'roles': roles,
          if (address != null) 'address': address,
          if (organizationId != null) 'organizationId': organizationId,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('createNewUser', e);
    }
  }

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// جلب قائمة المستخدمين النشطين.
  Future<Result<RemoteBaseModel, dynamic>> getActiveProfiles() async {
    try {
      JDRepoConsole.info(
        'Fetching active profiles',
        context: LogContext(module: 'UserSource', method: 'getActiveProfiles'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.activeProfiles}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getActiveProfiles', e);
    }
  }

  /// جلب إحصائيات الملفات الشخصية.
  Future<Result<RemoteBaseModel, dynamic>> getProfileStats() async {
    try {
      JDRepoConsole.info(
        'Fetching profile stats',
        context: LogContext(module: 'UserSource', method: 'getProfileStats'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.profileStats}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getProfileStats', e);
    }
  }

  /// جلب جميع المستخدمين الذين لديهم دور معين.
  /// مثال: role = "manager_role".
  Future<Result<RemoteBaseModel, dynamic>> getProfilesByRole(
    String role,
  ) async {
    try {
      JDRepoConsole.info(
        'Fetching profiles by role: $role',
        context:
            LogContext(module: 'UserSource', method: 'getProfilesByRole'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.profilesByRole(role)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getProfilesByRole', e);
    }
  }

  /// جلب بيانات مستخدم محدد بالـ ID.
  Future<Result<RemoteBaseModel, dynamic>> getProfileById(
    String userId,
  ) async {
    try {
      JDRepoConsole.info(
        'Fetching profile by id: $userId',
        context: LogContext(module: 'UserSource', method: 'getProfileById'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.profileById(userId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('getProfileById', e);
    }
  }

  // ─── Update ───────────────────────────────────────────────────────────────

  /// تحديث بيانات مستخدم معين (كـ Admin).
  Future<Result<RemoteBaseModel, dynamic>> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? phone,
    String? address,
    bool? isActive,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      JDRepoConsole.info(
        'Updating profile (admin): $userId',
        context: LogContext(module: 'UserSource', method: 'updateProfile'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.profileById(userId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (isActive != null) 'isActive': isActive,
          if (additionalFields != null) ...additionalFields,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('updateProfile', e);
    }
  }

  /// تحديث ملف شخصي المستخدم الحالي (My Profile).
  Future<Result<RemoteBaseModel, dynamic>> updateMyProfile({
    String? username,
    String? phone,
    String? address,
    String? bio,
    String? website,
    Map<String, dynamic>? socialLinks,
    Map<String, dynamic>? location,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      JDRepoConsole.info(
        'Updating my profile',
        context: LogContext(module: 'UserSource', method: 'updateMyProfile'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.myProfile}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {
          if (username != null) 'username': username,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (bio != null) 'bio': bio,
          if (website != null) 'website': website,
          if (socialLinks != null) 'socialLinks': socialLinks,
          if (location != null) 'location': location,
          if (additionalFields != null) ...additionalFields,
        },
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('updateMyProfile', e);
    }
  }

  // ─── Status Management ────────────────────────────────────────────────────

  /// تفعيل حساب مستخدم.
  Future<Result<RemoteBaseModel, dynamic>> activateUser(String userId) async {
    try {
      JDRepoConsole.info(
        'Activating user: $userId',
        context: LogContext(module: 'UserSource', method: 'activateUser'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.activateUser(userId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('activateUser', e);
    }
  }

  /// إلغاء تفعيل (إيقاف) حساب مستخدم.
  Future<Result<RemoteBaseModel, dynamic>> deactivateUser(String userId) async {
    try {
      JDRepoConsole.info(
        'Deactivating user: $userId',
        context: LogContext(module: 'UserSource', method: 'deactivateUser'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.deactivateUser(userId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('deactivateUser', e);
    }
  }

  // ─── Role Assignment ──────────────────────────────────────────────────────

  /// إضافة دور إلى مستخدم.
  Future<Result<RemoteBaseModel, dynamic>> addRoleToUser({
    required String userId,
    required String roleName,
  }) async {
    try {
      JDRepoConsole.info(
        'Adding role $roleName to user: $userId',
        context: LogContext(module: 'UserSource', method: 'addRoleToUser'),
      );
      final url = '${ApiUrls.BASE_URL}${EndPoints.userRoles(userId)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {'roleName': roleName},
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('addRoleToUser', e);
    }
  }

  /// إزالة دور محدد من مستخدم.
  Future<Result<RemoteBaseModel, dynamic>> removeRoleFromUser({
    required String userId,
    required String roleName,
  }) async {
    try {
      JDRepoConsole.info(
        'Removing role $roleName from user: $userId',
        context:
            LogContext(module: 'UserSource', method: 'removeRoleFromUser'),
      );
      final url =
          '${ApiUrls.BASE_URL}${EndPoints.removeUserRole(userId, roleName)}';
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError('removeRoleFromUser', e);
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
      context: LogContext(module: 'UserSource', method: method),
    );
    return Result.error(
      RemoteBaseModel(message: e.toString(), status: StatusModel.error),
    );
  }
}
