import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_requests.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_stats.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrganizationSource {
  Future<Result<RemoteBaseModel, dynamic>> createOrganizationWithOwner({
    required CreateOrgWithOwnerRequest request,
  }) async {
    try {
      JDRepoConsole.info("Creating organization with owner");
      String url = "${ApiUrls.BASE_URL}${EndPoints.createOrgWithOwner}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("createOrganizationWithOwner", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> createOrganizationForExistingUser({
    required CreateOrgForExistingUserRequest request,
  }) async {
    try {
      JDRepoConsole.info("Creating organization for existing user");
      String url = "${ApiUrls.BASE_URL}${EndPoints.createOrgForExistingUser}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("createOrganizationForExistingUser", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrganization({
    required String id,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.organizationById(id)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: updateData,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> activateOrganization(String id) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.activateOrganization(id)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("activateOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deactivateOrganization(String id) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.deactivateOrganization(id)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("deactivateOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> cloneOrganization({
    required OrganizationCloneRequest request,
  }) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.cloneOrganization}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("cloneOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationStats() async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.organizationStats}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationStats", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getCompleteOrganizations() async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.completeOrganizations}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getCompleteOrganizations", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getIncompleteOrganizations() async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.incompleteOrganizations}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getIncompleteOrganizations", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> searchByLocation(
    OrganizationLocationSearchRequest request,
  ) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.searchOrgByLocation}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        queryParameters: request.toQueryParams(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("searchByLocation", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> setTemplateStatus({
    required String id,
    required bool isTemplate,
  }) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.setOrgTemplateStatus(id)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {"isTemplate": isTemplate},
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("setTemplateStatus", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteOrganization(String id) async {
    try {
      String url = "${ApiUrls.BASE_URL}${EndPoints.organizationById(id)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("deleteOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getActiveOrganizations() async {
    try {
      JDRepoConsole.info(
        "Getting active organizations",
        context: LogContext(
          module: "OrganizationSource",
          method: "getActiveOrganizations",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.activeOrganizations}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("getActiveOrganizations", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationConfig(
    String organizationId,
  ) async {
    try {
      JDRepoConsole.info(
        "Getting organization config",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfig",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationConfigs(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationConfig", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationConfigSection({
    required String organizationId,
    required String section,
  }) async {
    try {
      JDRepoConsole.info(
        "Getting organization config section $section",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigSection",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationConfigsSection(organizationId, section)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationConfigSection", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrganizationConfig({
    required String organizationId,
    required Map<String, dynamic> configData,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating organization config",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfig",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationConfigs(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: configData,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrganizationConfig", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrganizationConfigSection({
    required String organizationId,
    required String section,
    required Map<String, dynamic> sectionData,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating organization config section",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfigSection",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationConfigsSection(organizationId, section)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: sectionData,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrganizationConfigSection", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationPolicy(
    String organizationId,
  ) async {
    try {
      JDRepoConsole.info(
        "Getting organization policy",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationPolicy",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationPolicies(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationPolicy", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrganizationPolicy({
    required String organizationId,
    required Map<String, dynamic> policyData,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating organization policy",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicy",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationPolicies(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: policyData,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrganizationPolicy", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrganizationPolicySection({
    required String organizationId,
    required String section,
    required Map<String, dynamic> sectionData,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating organization policy section",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicySection",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationPoliciesSection(organizationId, section)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: sectionData,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrganizationPolicySection", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationConfigByName(
    String orgName,
  ) async {
    try {
      JDRepoConsole.info(
        "Getting organization config by name",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigByName",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.organizationConfigsByName(orgName)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationConfigByName", e);
    }
  }

  Result<RemoteBaseModel, dynamic> _wrap(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }

    String? message = result.error?.message ?? result.data?.message;

    if (result.data?.data is Map) {
      final dataMap = result.data?.data as Map;
      final msg =
          dataMap['message'] ??
          dataMap['error'] ??
          dataMap['errors'] ??
          dataMap['detail'];
      if (msg != null) {
        if (msg is List) {
          message = msg.join(', ');
        } else {
          message = msg.toString();
        }
      }
    }

    return Result.error(
      RemoteBaseModel(
        message: message ?? 'خطأ غير معروف',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "OrganizationSource", method: method),
    );

    String message = "حدث خطأ غير متوقع";
    dynamic errorData;

    if (e is DioError) {
      errorData = e.response?.data;
      if (errorData is Map) {
        final msg =
            errorData['message'] ??
            errorData['error'] ??
            errorData['errors'] ??
            errorData['detail'];
        if (msg != null) {
          if (msg is List) {
            message = msg.join(', ');
          } else {
            message = msg.toString();
          }
        } else {
          message = e.message ?? "خطأ في الاتصال بالسيرفر";
        }
      } else {
        message = e.message ?? "خطأ في الاتصال بالسيرفر";
      }
    } else {
      message = e.toString();
    }

    return Result.error(
      RemoteBaseModel(
        message: message,
        status: StatusModel.error,
        data: errorData,
      ),
    );
  }
}
