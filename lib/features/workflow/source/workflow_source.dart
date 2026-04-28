import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:matger_pro_core_logic/features/workflow/request_body/workflow_request_bodies.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class WorkflowSource {
  WorkflowSource();

  Future<Result<RemoteBaseModel, dynamic>> performWorkflowAction({
    required String entityType,
    required String entryId,
    required WorkflowExecuteActionRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Performing workflow action: ${request.actionName} for $entityType: $entryId",
        context: LogContext(module: "WorkflowSource", method: "performWorkflowAction"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.performWorkflowAction(entityType, entryId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow action performed successfully",
          context: LogContext(module: "WorkflowSource", method: "performWorkflowAction"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("performWorkflowAction", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getWorkflowStatus({
    required String entityType,
    required String entryId,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching workflow status for $entityType: $entryId",
        context: LogContext(module: "WorkflowSource", method: "getWorkflowStatus"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.statusWorkflow(entityType, entryId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow status fetched successfully",
          context: LogContext(module: "WorkflowSource", method: "getWorkflowStatus"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getWorkflowStatus", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> claimWorkflowTask({
    required String entityType,
    required String entryId,
    WorkflowClaimTaskRequest? request,
  }) async {
    try {
      JDRepoConsole.info(
        "Claiming workflow task for $entityType: $entryId",
        context: LogContext(module: "WorkflowSource", method: "claimWorkflowTask"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.claimWorkflowTask(entityType, entryId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request?.toJson() ?? {},
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow task claimed successfully",
          context: LogContext(module: "WorkflowSource", method: "claimWorkflowTask"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("claimWorkflowTask", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> assignWorkflowTask({
    required String entityType,
    required String entryId,
    required WorkflowAssignTaskRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Assigning workflow task for $entityType: $entryId to ${request.targetUserId}",
        context: LogContext(module: "WorkflowSource", method: "assignWorkflowTask"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.assignWorkflowTask(entityType, entryId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow task assigned successfully",
          context: LogContext(module: "WorkflowSource", method: "assignWorkflowTask"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("assignWorkflowTask", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> seedWorkflowConfig({
    required String orgId,
    WorkflowSeedRequest? request,
  }) async {
    try {
      JDRepoConsole.info(
        "Seeding workflow config for org: $orgId",
        context: LogContext(module: "WorkflowSource", method: "seedWorkflowConfig"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.seedWorkflowConfig(orgId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request?.toJson() ?? {},
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow config seeded successfully",
          context: LogContext(module: "WorkflowSource", method: "seedWorkflowConfig"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("seedWorkflowConfig", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getWorkflowConfig({
    required String orgId,
    required String entityType,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching workflow configs for org: $orgId, entity: $entityType",
        context: LogContext(module: "WorkflowSource", method: "getWorkflowConfig"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.getWorkflowConfig(orgId, entityType)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow config fetched successfully",
          context: LogContext(module: "WorkflowSource", method: "getWorkflowConfig"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getWorkflowConfig", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> createWorkflowConfig({
    required String orgId,
    required WorkflowConfigRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating/Updating workflow config for org: $orgId",
        context: LogContext(module: "WorkflowSource", method: "createWorkflowConfig"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.createWorkflowConfig(orgId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Workflow config saved successfully",
          context: LogContext(module: "WorkflowSource", method: "createWorkflowConfig"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("createWorkflowConfig", e);
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
        message: message ?? 'خطأ غير معروف في الباك اند',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "WorkflowSource", method: method),
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
