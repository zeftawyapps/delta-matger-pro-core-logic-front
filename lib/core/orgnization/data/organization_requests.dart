import 'package:matger_pro_core_logic/core/orgnization/data/organization_model.dart';

/// Request body for cloning settings from one organization to another
class OrganizationCloneRequest {
  final String templateOrgId;
  final String targetOrgId;
  final bool? overwrite;

  OrganizationCloneRequest({
    required this.templateOrgId,
    required this.targetOrgId,
    this.overwrite,
  });

  Map<String, dynamic> toJson() {
    return {
      'templateOrgId': templateOrgId,
      'targetOrgId': targetOrgId,
      if (overwrite != null) 'overwrite': overwrite,
    };
  }
}

/// Request body for setting a template status
class OrganizationTemplateStatusRequest {
  final bool isTemplate;

  OrganizationTemplateStatusRequest({required this.isTemplate});

  Map<String, dynamic> toJson() => {'isTemplate': isTemplate};
}

/// Request body for creating an organization for an existing user
class CreateOrgForExistingUserRequest {
  final String userId;
  final Map<String, dynamic> organizationData;
  final String? templateOrgId;

  CreateOrgForExistingUserRequest({
    required this.userId,
    required this.organizationData,
    this.templateOrgId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'organizationData': organizationData,
      if (templateOrgId != null) 'templateOrgId': templateOrgId,
    };
  }
}

/// Request body for creating an organization with a new owner
class CreateOrgWithOwnerRequest {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> organizationData;
  final String? templateOrgId;

  CreateOrgWithOwnerRequest({
    required this.userData,
    required this.organizationData,
    this.templateOrgId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userData': userData,
      'organizationData': organizationData,
      if (templateOrgId != null) 'templateOrgId': templateOrgId,
    };
  }
}

/// Request body for location search
class OrganizationLocationSearchRequest {
  final double lat;
  final double lng;
  final double radius;

  OrganizationLocationSearchRequest({
    required this.lat,
    required this.lng,
    required this.radius,
  });

  Map<String, dynamic> toQueryParams() {
    return {
      'lat': lat,
      'lng': lng,
      'radius': radius,
    };
  }
}
