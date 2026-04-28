import 'package:matger_pro_core_logic/core/auth/data/user_model.dart';
import 'permission_constants.dart';

/// A class to manage and check user permissions according to the backend structure: `feature:job`.
class PermissionManager {
  /// Checks if the given list of permissions contains the permission for the specific [feature] and [job].
  ///
  /// * The wildcard `*:*` grants all access.
  /// * The wildcard `feature:*` grants all actions for that feature.
  /// * Exact matches `feature:job` grant specific access.
  static bool hasPermission(
    List<String>? userPermissions,
    String feature,
    String job,
  ) {
    if (userPermissions == null || userPermissions.isEmpty) return false;

    // A "*" permission implies full access to everything.
    if (userPermissions.contains('*:*')) return true;

    // A "feature:*" permission implies full access to all jobs of that feature.
    if (userPermissions.contains('$feature:*')) return true;

    // Check for the exact feature and job.
    return userPermissions.contains('$feature:$job');
  }

  /// Get translation for a feature
  static String getFeatureLabel(String featureKey, {String lang = 'ar'}) {
    return SystemFeatures.translations[featureKey]?[lang] ?? featureKey;
  }

  /// Get translation for a job
  static String getJobLabel(String jobKey, {String lang = 'ar'}) {
    return SystemJobs.translations[jobKey]?[lang] ?? jobKey;
  }
}

/// Extension on [UserModel] to easily check for permissions.
extension UserPermissionExtension on UserModel {
  /// Checks if the user has the specified permission.
  bool can(String feature, String job) {
    return PermissionManager.hasPermission(permissions, feature, job);
  }

  /// Check if the user is a super admin (has *:* permission)
  bool get isSuperAdmin {
    return permissions?.contains('*:*') ?? false;
  }

  /// Check if the user can view a specific screen
  bool canView(String screenKey) {
    // Ensuring it uses screen. prefix if missing (optional step based on consistency)
    final key = screenKey.startsWith('screen.')
        ? screenKey
        : 'screen.$screenKey';
    return can(key, SystemJobs.view);
  }
}
