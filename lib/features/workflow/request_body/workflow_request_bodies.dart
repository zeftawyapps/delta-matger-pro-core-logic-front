/// Request body for executing a workflow action (e.g., Approve, Reject)
class WorkflowExecuteActionRequest {
  final String actionName;
  final int? expectedStepNumber;
  final String? targetUserId;

  WorkflowExecuteActionRequest({
    required this.actionName,
    this.expectedStepNumber,
    this.targetUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'actionName': actionName,
      if (expectedStepNumber != null) 'expectedStepNumber': expectedStepNumber,
      if (targetUserId != null) 'targetUserId': targetUserId,
    };
  }
}

/// Request body for claiming a task
class WorkflowClaimTaskRequest {
  final int? expectedStepNumber;

  WorkflowClaimTaskRequest({this.expectedStepNumber});

  Map<String, dynamic> toJson() {
    return {
      if (expectedStepNumber != null) 'expectedStepNumber': expectedStepNumber,
    };
  }
}

/// Request body for administratively assigning a task
class WorkflowAssignTaskRequest {
  final String targetUserId;
  final int? expectedStepNumber;

  WorkflowAssignTaskRequest({
    required this.targetUserId,
    this.expectedStepNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'targetUserId': targetUserId,
      if (expectedStepNumber != null) 'expectedStepNumber': expectedStepNumber,
    };
  }
}

/// Request body for seeding a default workflow
class WorkflowSeedRequest {
  final String entityType;

  WorkflowSeedRequest({this.entityType = 'orders'});

  Map<String, dynamic> toJson() {
    return {
      'entityType': entityType,
    };
  }
}

/// Request body for creating/updating workflow configuration
class WorkflowConfigRequest {
  final String entityType;
  final String name;
  final String? description;
  final String? workflowSlug;
  final List<Map<String, dynamic>> steps;
  final List<String>? roleExecutor;

  WorkflowConfigRequest({
    required this.entityType,
    required this.name,
    this.description,
    this.workflowSlug,
    required this.steps,
    this.roleExecutor,
  });

  Map<String, dynamic> toJson() {
    return {
      'entityType': entityType,
      'name': name,
      if (description != null) 'description': description,
      if (workflowSlug != null) 'workflowSlug': workflowSlug,
      'steps': steps,
      if (roleExecutor != null) 'roleExecutor': roleExecutor,
    };
  }
}
