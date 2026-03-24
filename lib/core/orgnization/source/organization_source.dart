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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization created successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "createOrganizationWithOwner",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Organization creation failed",
        context: LogContext(
          module: "OrganizationSource",
          method: "createOrganizationWithOwner",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error creating organization: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "createOrganizationWithOwner",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Active organizations retrieved successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "getActiveOrganizations",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to get active organizations",
        context: LogContext(
          module: "OrganizationSource",
          method: "getActiveOrganizations",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error getting active organizations: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "getActiveOrganizations",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization config retrieved successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "getOrganizationConfig",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to get organization config",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfig",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error getting organization config: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfig",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization config section retrieved successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "getOrganizationConfigSection",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to get organization config section",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigSection",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error getting organization config section: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigSection",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization config updated successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "updateOrganizationConfig",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to update organization config",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfig",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error updating organization config: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfig",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization config section updated successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "updateOrganizationConfigSection",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to update organization config section",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfigSection",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error updating organization config section: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationConfigSection",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization policy retrieved successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "getOrganizationPolicy",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to get organization policy",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationPolicy",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error getting organization policy: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationPolicy",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization policy updated successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "updateOrganizationPolicy",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to update organization policy",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicy",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error updating organization policy: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicy",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization policy section updated successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "updateOrganizationPolicySection",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to update organization policy section",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicySection",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error updating organization policy section: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "updateOrganizationPolicySection",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Organization config by name retrieved successfully",
          context: LogContext(
            module: "OrganizationSource",
            method: "getOrganizationConfigByName",
          ),
        );
        return Result.data(result.data?.data);
      }
      JDRepoConsole.error(
        "Failed to get organization config by name",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigByName",
          metadata: result.error,
        ),
      );
      return Result.error(
        RemoteBaseModel(
          message: result.error?.message ?? result.data?.message,
          status: result.data?.status ?? StatusModel.error,
        ),
      );
    } catch (e) {
      JDRepoConsole.error(
        "Error getting organization config by name: $e",
        context: LogContext(
          module: "OrganizationSource",
          method: "getOrganizationConfigByName",
        ),
      );
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }
}
