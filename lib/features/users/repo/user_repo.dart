import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_core_logic/core/auth/data/user_profile_model.dart';
import 'package:matger_core_logic/features/users/source/user_source.dart';

class UserRepo {
  late final UserSource _userSource;

  UserRepo({UserSource? userSource}) {
    _userSource = userSource ?? UserSource();
  }

  // ─── Create ───────────────────────────────────────────────────────────────

  /// إنشاء مستخدم أو موظف جديد وربطه بأدوار مخصصة.
  Future<RemoteBaseModel<UserProfileModel>> createNewUser({
    required String username,
    required String email,
    required String password,
    required String phone,
    List<String> roles = const [],
    String? address,
    String? organizationId,
  }) async {
    JDRepoConsole.info(
      'Creating new user in repo: $username',
      context: LogContext(module: 'UserRepo', method: 'createNewUser'),
    );
    final result = await _userSource.createNewUser(
      username: username,
      email: email,
      password: password,
      phone: phone,
      roles: roles,
      address: address,
      organizationId: organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in createNewUser: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'createNewUser'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'createNewUser');
  }

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// جلب قائمة المستخدمين النشطين.
  Future<RemoteBaseModel<List<UserProfileModel>>> getActiveProfiles() async {
    JDRepoConsole.info(
      'Getting active profiles in repo',
      context: LogContext(module: 'UserRepo', method: 'getActiveProfiles'),
    );
    final result = await _userSource.getActiveProfiles();

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getActiveProfiles: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'getActiveProfiles'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseList(result.data, 'getActiveProfiles');
  }

  /// جلب إحصائيات الملفات الشخصية (يُرجع Map خام لمرونة البيانات).
  Future<RemoteBaseModel<Map<String, dynamic>>> getProfileStats() async {
    JDRepoConsole.info(
      'Getting profile stats in repo',
      context: LogContext(module: 'UserRepo', method: 'getProfileStats'),
    );
    final result = await _userSource.getProfileStats();

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getProfileStats: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'getProfileStats'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final stats = result.data is Map<String, dynamic>
          ? result.data as Map<String, dynamic>
          : <String, dynamic>{};
      JDRepoConsole.success(
        'Profile stats fetched successfully',
        context: LogContext(module: 'UserRepo', method: 'getProfileStats'),
      );
      return RemoteBaseModel(data: stats, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in getProfileStats: $e',
        context: LogContext(
          module: 'UserRepo',
          method: 'getProfileStats',
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }

  /// جلب جميع المستخدمين الذين لديهم دور معين.
  Future<RemoteBaseModel<List<UserProfileModel>>> getProfilesByRole(
    String role,
  ) async {
    JDRepoConsole.info(
      'Getting profiles by role in repo: $role',
      context: LogContext(module: 'UserRepo', method: 'getProfilesByRole'),
    );
    final result = await _userSource.getProfilesByRole(role);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getProfilesByRole: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'getProfilesByRole'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseList(result.data, 'getProfilesByRole');
  }

  /// جلب بيانات مستخدم محدد بالـ ID.
  Future<RemoteBaseModel<UserProfileModel>> getProfileById(
    String userId,
  ) async {
    JDRepoConsole.info(
      'Getting profile by id in repo: $userId',
      context: LogContext(module: 'UserRepo', method: 'getProfileById'),
    );
    final result = await _userSource.getProfileById(userId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in getProfileById: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'getProfileById'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'getProfileById');
  }

  // ─── Update ───────────────────────────────────────────────────────────────

  /// تحديث بيانات مستخدم معين (كـ Admin).
  Future<RemoteBaseModel<UserProfileModel>> updateProfile({
    required String userId,
    String? username,
    String? email,
    String? phone,
    String? address,
    bool? isActive,
    Map<String, dynamic>? additionalFields,
  }) async {
    JDRepoConsole.info(
      'Updating profile in repo (admin): $userId',
      context: LogContext(module: 'UserRepo', method: 'updateProfile'),
    );
    final result = await _userSource.updateProfile(
      userId: userId,
      username: username,
      email: email,
      phone: phone,
      address: address,
      isActive: isActive,
      additionalFields: additionalFields,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in updateProfile: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'updateProfile'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'updateProfile');
  }

  /// تحديث ملف شخصي المستخدم الحالي (My Profile).
  Future<RemoteBaseModel<UserProfileModel>> updateMyProfile({
    String? username,
    String? phone,
    String? address,
    String? bio,
    String? website,
    Map<String, dynamic>? socialLinks,
    Map<String, dynamic>? location,
    Map<String, dynamic>? additionalFields,
  }) async {
    JDRepoConsole.info(
      'Updating my profile in repo',
      context: LogContext(module: 'UserRepo', method: 'updateMyProfile'),
    );
    final result = await _userSource.updateMyProfile(
      username: username,
      phone: phone,
      address: address,
      bio: bio,
      website: website,
      socialLinks: socialLinks,
      location: location,
      additionalFields: additionalFields,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in updateMyProfile: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'updateMyProfile'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return _parseSingle(result.data, 'updateMyProfile');
  }

  // ─── Status Management ────────────────────────────────────────────────────

  /// تفعيل حساب مستخدم.
  Future<RemoteBaseModel<bool>> activateUser(String userId) async {
    JDRepoConsole.info(
      'Activating user in repo: $userId',
      context: LogContext(module: 'UserRepo', method: 'activateUser'),
    );
    final result = await _userSource.activateUser(userId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in activateUser: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'activateUser'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      'User activated successfully in repo',
      context: LogContext(module: 'UserRepo', method: 'activateUser'),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  /// إلغاء تفعيل (إيقاف) حساب مستخدم.
  Future<RemoteBaseModel<bool>> deactivateUser(String userId) async {
    JDRepoConsole.info(
      'Deactivating user in repo: $userId',
      context: LogContext(module: 'UserRepo', method: 'deactivateUser'),
    );
    final result = await _userSource.deactivateUser(userId);

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in deactivateUser: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'deactivateUser'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      'User deactivated successfully in repo',
      context: LogContext(module: 'UserRepo', method: 'deactivateUser'),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  // ─── Role Assignment ──────────────────────────────────────────────────────

  /// إضافة دور إلى مستخدم.
  Future<RemoteBaseModel<bool>> addRoleToUser({
    required String userId,
    required String roleName,
  }) async {
    JDRepoConsole.info(
      'Adding role $roleName to user in repo: $userId',
      context: LogContext(module: 'UserRepo', method: 'addRoleToUser'),
    );
    final result = await _userSource.addRoleToUser(
      userId: userId,
      roleName: roleName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in addRoleToUser: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'addRoleToUser'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      'Role added successfully to user in repo',
      context: LogContext(module: 'UserRepo', method: 'addRoleToUser'),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  /// إزالة دور محدد من مستخدم.
  Future<RemoteBaseModel<bool>> removeRoleFromUser({
    required String userId,
    required String roleName,
  }) async {
    JDRepoConsole.info(
      'Removing role $roleName from user in repo: $userId',
      context: LogContext(module: 'UserRepo', method: 'removeRoleFromUser'),
    );
    final result = await _userSource.removeRoleFromUser(
      userId: userId,
      roleName: roleName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        'Source error in removeRoleFromUser: ${result.error?.message}',
        context: LogContext(module: 'UserRepo', method: 'removeRoleFromUser'),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      'Role removed successfully from user in repo',
      context: LogContext(module: 'UserRepo', method: 'removeRoleFromUser'),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  // ─── Parsing Helpers ──────────────────────────────────────────────────────

  RemoteBaseModel<UserProfileModel> _parseSingle(
    dynamic data,
    String method,
  ) {
    try {
      final Map<String, dynamic> raw;
      if (data is Map<String, dynamic>) {
        raw = (data.containsKey('data') && data['data'] is Map)
            ? data['data'] as Map<String, dynamic>
            : data;
      } else {
        raw = <String, dynamic>{};
      }

      final user = UserProfileModel.fromJson(raw);
      JDRepoConsole.success(
        'User profile parsed successfully ($method)',
        context: LogContext(module: 'UserRepo', method: method),
      );
      return RemoteBaseModel(data: user, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in $method: $e',
        context: LogContext(module: 'UserRepo', method: method, metadata: data),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }

  RemoteBaseModel<List<UserProfileModel>> _parseList(
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

      final users = rawList
          .map((e) => UserProfileModel.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        'Fetched ${users.length} user profiles successfully ($method)',
        context: LogContext(module: 'UserRepo', method: method),
      );
      return RemoteBaseModel(data: users, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        'Parsing error in $method: $e',
        context: LogContext(module: 'UserRepo', method: method, metadata: data),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: 'Parsing Error: $e',
      );
    }
  }
}
