import 'package:matger_pro_core_logic/features/workflow/source/workflow_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:matger_pro_core_logic/features/workflow/request_body/workflow_request_bodies.dart';
import 'package:matger_pro_core_logic/features/workflow/data/workflow_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class WorkflowRepo {
  final WorkflowSource _source;
  WorkflowRepo({WorkflowSource? source}) : _source = source ?? WorkflowSource();

  Future<RemoteBaseModel<T>> performAction<T>({
    required String entityType,
    required String entryId,
    required WorkflowExecuteActionRequest request,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    JDRepoConsole.info(
      "Performing workflow action: ${request.actionName} for $entityType",
      context: LogContext(module: "WorkflowRepo", method: "performAction"),
    );
    final result = await _source.performWorkflowAction(
      entityType: entityType,
      entryId: entryId,
      request: request,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in performAction: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "performAction"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      
      if (parser != null) {
        final parsedData = parser(data);
        JDRepoConsole.success(
          "Workflow action result parsed successfully",
          context: LogContext(module: "WorkflowRepo", method: "performAction"),
        );
        return RemoteBaseModel(data: parsedData, status: StatusModel.success);
      }
      
      // Default fallback for backward compatibility
      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config parsed successfully after action",
        context: LogContext(module: "WorkflowRepo", method: "performAction"),
      );
      return RemoteBaseModel(data: config as T, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in performAction: $e",
        context: LogContext(module: "WorkflowRepo", method: "performAction"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تنفيذ إجراء سير العمل",
      );
    }
  }

  Future<RemoteBaseModel<T>> getStatus<T>({
    required String entityType,
    required String entryId,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    JDRepoConsole.info(
      "Getting workflow status for $entityType: $entryId",
      context: LogContext(module: "WorkflowRepo", method: "getStatus"),
    );
    final result = await _source.getWorkflowStatus(
      entityType: entityType,
      entryId: entryId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getStatus: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "getStatus"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      
      if (parser != null) {
        final parsedData = parser(data);
        JDRepoConsole.success(
          "Workflow status parsed successfully",
          context: LogContext(module: "WorkflowRepo", method: "getStatus"),
        );
        return RemoteBaseModel(data: parsedData, status: StatusModel.success);
      }

      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config parsed successfully for status",
        context: LogContext(module: "WorkflowRepo", method: "getStatus"),
      );
      return RemoteBaseModel(data: config as T, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getStatus: $e",
        context: LogContext(module: "WorkflowRepo", method: "getStatus"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب حالة سير العمل",
      );
    }
  }

  Future<RemoteBaseModel<T>> claimTask<T>({
    required String entityType,
    required String entryId,
    WorkflowClaimTaskRequest? request,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    JDRepoConsole.info(
      "Claiming workflow task for $entityType: $entryId",
      context: LogContext(module: "WorkflowRepo", method: "claimTask"),
    );
    final result = await _source.claimWorkflowTask(
      entityType: entityType,
      entryId: entryId,
      request: request,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in claimTask: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "claimTask"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      
      if (parser != null) {
        final parsedData = parser(data);
        JDRepoConsole.success(
          "Claim task result parsed successfully",
          context: LogContext(module: "WorkflowRepo", method: "claimTask"),
        );
        return RemoteBaseModel(data: parsedData, status: StatusModel.success);
      }

      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config parsed successfully after claim",
        context: LogContext(module: "WorkflowRepo", method: "claimTask"),
      );
      return RemoteBaseModel(data: config as T, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in claimTask: $e",
        context: LogContext(module: "WorkflowRepo", method: "claimTask"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في استلام المهمة",
      );
    }
  }

  Future<RemoteBaseModel<T>> assignTask<T>({
    required String entityType,
    required String entryId,
    required WorkflowAssignTaskRequest request,
    T Function(Map<String, dynamic>)? parser,
  }) async {
    JDRepoConsole.info(
      "Assigning workflow task for $entityType: $entryId to ${request.targetUserId}",
      context: LogContext(module: "WorkflowRepo", method: "assignTask"),
    );
    final result = await _source.assignWorkflowTask(
      entityType: entityType,
      entryId: entryId,
      request: request,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in assignTask: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "assignTask"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      
      if (parser != null) {
        final parsedData = parser(data);
        JDRepoConsole.success(
          "Assign task result parsed successfully",
          context: LogContext(module: "WorkflowRepo", method: "assignTask"),
        );
        return RemoteBaseModel(data: parsedData, status: StatusModel.success);
      }

      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config parsed successfully after assignment",
        context: LogContext(module: "WorkflowRepo", method: "assignTask"),
      );
      return RemoteBaseModel(data: config as T, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in assignTask: $e",
        context: LogContext(module: "WorkflowRepo", method: "assignTask"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تعيين المهمة",
      );
    }
  }

  Future<RemoteBaseModel<WorkflowConfig>> seedConfig({
    required String orgId,
    WorkflowSeedRequest? request,
  }) async {
    JDRepoConsole.info(
      "Seeding workflow config for org: $orgId",
      context: LogContext(module: "WorkflowRepo", method: "seedConfig"),
    );
    final result = await _source.seedWorkflowConfig(
      orgId: orgId,
      request: request,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in seedConfig: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "seedConfig"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config seeded successfully",
        context: LogContext(module: "WorkflowRepo", method: "seedConfig"),
      );
      return RemoteBaseModel(data: config, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in seedConfig: $e",
        context: LogContext(
          module: "WorkflowRepo",
          method: "seedConfig",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تهيئة إعدادات سير العمل",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<WorkflowConfig>>> getWorkflowConfig({
    required String orgId,
    required String entityType,
  }) async {
    JDRepoConsole.info(
      "Fetching workflow config for org: $orgId, entity: $entityType",
      context: LogContext(module: "WorkflowRepo", method: "getWorkflowConfig"),
    );
    final result = await _source.getWorkflowConfig(
      orgId: orgId,
      entityType: entityType,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getWorkflowConfig: ${result.error?.message}",
        context: LogContext(
          module: "WorkflowRepo",
          method: "getWorkflowConfig",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List<dynamic> dataList;

      if (rawData is List) {
        dataList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data')) ? rawData['data'] : rawData;
        if (data is List) {
          dataList = data;
        } else if (data is Map) {
          dataList = [data];
        } else {
          dataList = [];
        }
      } else {
        dataList = [];
      }

      final configs = dataList
          .map((e) => WorkflowConfig.fromJson(e as Map<String, dynamic>))
          .toList();

      JDRepoConsole.success(
        "Workflow configs fetched successfully: ${configs.length} items",
        context: LogContext(
          module: "WorkflowRepo",
          method: "getWorkflowConfig",
        ),
      );
      return RemoteBaseModel(data: configs, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getWorkflowConfig: $e",
        context: LogContext(
          module: "WorkflowRepo",
          method: "getWorkflowConfig",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب إعدادات سير العمل",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<WorkflowConfig>> createConfig({
    required String orgId,
    required WorkflowConfigRequest request,
  }) async {
    JDRepoConsole.info(
      "Creating/Updating workflow config for org: $orgId",
      context: LogContext(module: "WorkflowRepo", method: "createConfig"),
    );
    final result = await _source.createWorkflowConfig(
      orgId: orgId,
      request: request,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createConfig: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "createConfig"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final config = WorkflowConfig.fromJson(data);
      JDRepoConsole.success(
        "Workflow config saved and parsed successfully",
        context: LogContext(module: "WorkflowRepo", method: "createConfig"),
      );
      return RemoteBaseModel(data: config, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createConfig: $e",
        context: LogContext(
          module: "WorkflowRepo",
          method: "createConfig",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في حفظ إعدادات سير العمل",
        data: null,
      );
    }
  }
  Future<RemoteBaseModel<WorkflowData>> getTemplate({
    required String slug,
  }) async {
    return getWorkflowTemplate<WorkflowData>(
      slug: slug,
      parser: (data) => WorkflowData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<T>> getWorkflowTemplate<T>({
    required String slug,
    required T Function(Map<String, dynamic>) parser,
  }) async {
    JDRepoConsole.info(
      "Fetching workflow template for slug: $slug",
      context: LogContext(module: "WorkflowRepo", method: "getWorkflowTemplate"),
    );
    final result = await _source.getWorkflowTemplate(slug: slug);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getWorkflowTemplate for slug $slug: ${result.error?.message}",
        context: LogContext(module: "WorkflowRepo", method: "getWorkflowTemplate"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data as Map<String, dynamic>;
      // Extract data object if nested
      final finalData = (data.containsKey('data') && data['data'] is Map)
          ? data['data'] as Map<String, dynamic>
          : data;
      final parsedData = parser(finalData);
      JDRepoConsole.success(
        "Workflow template for slug $slug parsed successfully",
        context: LogContext(module: "WorkflowRepo", method: "getWorkflowTemplate"),
      );
      return RemoteBaseModel(data: parsedData, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getWorkflowTemplate for slug $slug: $e",
        context: LogContext(module: "WorkflowRepo", method: "getWorkflowTemplate"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب قالب سير العمل",
      );
    }
  }
}
