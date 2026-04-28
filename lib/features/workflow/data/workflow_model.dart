import 'package:matger_pro_core_logic/models/localized_string.dart';

class WorkflowConfig {
  final String id;
  final String organizationId;
  final String entityType;
  final String workflowSlug;
  final String roleExecutor;
  final bool isActive;
  final DateTime? createdAt;
  final WorkflowData workflow;
  final WorkflowMeta? meta;

  WorkflowConfig({
    required this.id,
    required this.organizationId,
    required this.entityType,
    required this.workflowSlug,
    required this.roleExecutor,
    required this.isActive,
    this.createdAt,
    required this.workflow,
    this.meta,
  });

  factory WorkflowConfig.fromJson(Map<String, dynamic> json) {
    return WorkflowConfig(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      entityType: json['entityType'] as String? ?? '',
      workflowSlug: json['workflowSlug'] as String? ?? '',
      roleExecutor: json['roleExecutor'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      workflow: WorkflowData.fromJson(json['workflow'] as Map<String, dynamic>),
      meta: json['meta'] != null
          ? WorkflowMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'organizationId': organizationId,
      'entityType': entityType,
      'workflowSlug': workflowSlug,
      'roleExecutor': roleExecutor,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'workflow': workflow.toJson(),
      'meta': meta?.toJson(),
    };
  }
}

class WorkflowMeta {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  WorkflowMeta({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.isActive,
  });

  factory WorkflowMeta.fromJson(Map<String, dynamic> json) {
    return WorkflowMeta(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class WorkflowData {
  final LocalizedString workflowName;
  final LocalizedString? workflowDescription;
  final int currentStepIndex;
  final List<WorkflowStep> steps;

  WorkflowData({
    required this.workflowName,
    this.workflowDescription,
    this.currentStepIndex = 0,
    required this.steps,
  });

  factory WorkflowData.fromJson(Map<String, dynamic> json) {
    return WorkflowData(
      workflowName: LocalizedString.fromJson(json['workflowName']),
      workflowDescription: json['workflowDescription'] != null
          ? LocalizedString.fromJson(json['workflowDescription'])
          : null,
      currentStepIndex: json['currentStepIndex'] as int? ?? 0,
      steps: (json['steps'] as List? ?? [])
          .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
          .toList()
          .cast<WorkflowStep>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workflowName': workflowName.toJson(),
      if (workflowDescription != null)
        'workflowDescription': workflowDescription?.toJson(),
      'currentStepIndex': currentStepIndex,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkflowStep {
  final String id;
  final String stepKey;
  final int stepNumber;
  final LocalizedString stepName;
  final String stepRole;
  final String stepColor;
  final String selectionMode;
  final String targetType;
  final int requiredApprovalsCount;
  final String statusTag;
  final List<WorkflowAction> actions;

  WorkflowStep({
    required this.id,
    required this.stepKey,
    required this.stepNumber,
    required this.stepName,
    required this.stepRole,
    required this.stepColor,
    required this.selectionMode,
    required this.targetType,
    required this.requiredApprovalsCount,
    required this.statusTag,
    required this.actions,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      id: json['_id'] as String? ?? '',
      stepKey: json['stepKey'] as String? ?? '',
      stepNumber: json['stepNumber'] as int? ?? 0,
      stepName: LocalizedString.fromJson(json['stepName']),
      stepRole: json['stepRole'] as String? ?? '',
      stepColor: json['stepColor'] as String? ?? '#000000',
      selectionMode: json['selectionMode'] as String? ?? '',
      targetType: json['targetType'] as String? ?? 'user',
      requiredApprovalsCount: json['requiredApprovalsCount'] as int? ?? 1,
      statusTag: json['statusTag'] as String? ?? '',
      actions: (json['action'] as List? ?? json['actions'] as List? ?? [])
          .map((e) => WorkflowAction.fromJson(e as Map<String, dynamic>))
          .toList()
          .cast<WorkflowAction>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'stepKey': stepKey,
      'stepNumber': stepNumber,
      'stepName': stepName.toJson(),
      'stepRole': stepRole,
      'stepColor': stepColor,
      'selectionMode': selectionMode,
      'targetType': targetType,
      'requiredApprovalsCount': requiredApprovalsCount,
      'statusTag': statusTag,
      'action': actions.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkflowAction {
  final String id;
  final String actionKey;
  final LocalizedString actionName;
  final int actionReturnToStepIndex;
  final String actionReturnToStepKey;
  final LocalizedString? actionDescription;

  WorkflowAction({
    required this.id,
    required this.actionKey,
    required this.actionName,
    required this.actionReturnToStepIndex,
    required this.actionReturnToStepKey,
    this.actionDescription,
  });

  factory WorkflowAction.fromJson(Map<String, dynamic> json) {
    return WorkflowAction(
      id: json['_id'] as String? ?? '',
      actionKey: json['actionKey'] as String? ?? '',
      actionName: LocalizedString.fromJson(json['actionName']),
      actionReturnToStepIndex: json['actionReturnToStepIndex'] as int? ?? 0,
      actionReturnToStepKey: json['actionReturnToStepKey'] as String? ?? '',
      actionDescription: json['actionDescription'] != null
          ? LocalizedString.fromJson(json['actionDescription'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'actionKey': actionKey,
      'actionName': actionName.toJson(),
      'actionReturnToStepIndex': actionReturnToStepIndex,
      'actionReturnToStepKey': actionReturnToStepKey,
      if (actionDescription != null)
        'actionDescription': actionDescription?.toJson(),
    };
  }
}
