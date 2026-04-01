import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrganizationSource {
  Future<Result<RemoteBaseModel, dynamic>> createOrganizationWithOwner({
    required Map<String, dynamic> userData,
    required Map<String, dynamic> organizationData,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating organization with owner",
        context: LogContext(
          module: "OrganizationSource",
          method: "createOrganizationWithOwner",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.createOrgWithOwner}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {"userData": userData, "organizationData": organizationData},
        cancelToken: CancelToken(),
      );

      return _wrap(result);
    } catch (e) {
      return _catchError("createOrganizationWithOwner", e);
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
      final msg = dataMap['message'] ??
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

    if (e is DioException) {
      errorData = e.response?.data;
      if (errorData is Map) {
        final msg = errorData['message'] ??
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
