import 'package:matger_pro_core_logic/models/entity_meta.dart';
import 'package:matger_pro_core_logic/utls/type_parser.dart';
import 'package:matger_pro_core_logic/models/localized_string.dart';

class OrderData {
  final String id;
  final String organizationId;
  final OrderContactDetails? senderDetails;
  final OrderContactDetails? recipientDetails;
  final List<OrderItemData> items;
  final double totalOrderPrice;
  final String orderMode;
  final String status;
  final OrderWorkFlow? workFlow;
  final EntityMeta? meta;
  final String? workflowSlug;
  final String? handlerUserId;
  final String? handlerOrgId;
  final Map<String, double> additionalCalculation;
  final Map<String, dynamic> additionalData;

  OrderData({
    required this.id,
    required this.organizationId,
    this.senderDetails,
    this.recipientDetails,
    this.items = const [],
    required this.totalOrderPrice,
    this.orderMode = 'C2B',
    this.status = 'pending',
    this.workFlow,
    this.meta,
    this.workflowSlug,
    this.handlerUserId,
    this.handlerOrgId,
    this.additionalCalculation = const {},
    this.additionalData = const {},
  });

  // Alias for backward compatibility
  String get orderId => id;
  double get totalAmount => totalOrderPrice;

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final coreFields = [
      'id',
      'orderId',
      'organizationId',
      'senderDetails',
      'recipientDetails',
      'items',
      'totalOrderPrice',
      'totalAmount',
      'totalPrice',
      'orderMode',
      'status',
      'workFlow',
      'meta',
      'workflowSlug',
      'handlerUserId',
      'handlerOrgId',
    ];

    final additional = Map<String, dynamic>.from(json)
      ..removeWhere((key, value) => coreFields.contains(key));

    return OrderData(
      id: (json['id'] ?? json['orderId'] ?? '') as String,
      organizationId: (json['organizationId'] ?? '') as String,
      senderDetails: json['senderDetails'] != null
          ? OrderContactDetails.fromJson(json['senderDetails'])
          : null,
      recipientDetails: json['recipientDetails'] != null
          ? OrderContactDetails.fromJson(json['recipientDetails'])
          : null,
      items: (json['items'] as List?)
              ?.map((e) => OrderItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalOrderPrice: TypeParser.parseDouble(
          json['totalOrderPrice'] ?? json['totalAmount'] ?? json['totalPrice']),
      orderMode: (json['orderMode'] as String? ?? 'C2B'),
      status: (json['status'] as String? ?? 'pending'),
      workFlow: json['workFlow'] != null || json['workflow'] != null
          ? OrderWorkFlow.fromJson(json['workFlow'] ?? json['workflow'])
          : null,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
      workflowSlug: json['workflowSlug'] as String?,
      handlerUserId: json['handlerUserId'] as String?,
      handlerOrgId: json['handlerOrgId'] as String?,
      additionalCalculation: json['additionalCalculation'] is Map
          ? (json['additionalCalculation'] as Map).map(
              (k, v) => MapEntry(k.toString(), TypeParser.parseDouble(v)))
          : const {},
      additionalData: additional,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'senderDetails': senderDetails?.toJson(),
      'recipientDetails': recipientDetails?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'totalOrderPrice': totalOrderPrice,
      'orderMode': orderMode,
      'status': status,
      'workFlow': workFlow?.toJson(),
      'meta': meta?.toJson(),
      'workflowSlug': workflowSlug,
      'handlerUserId': handlerUserId,
      'handlerOrgId': handlerOrgId,
      'additionalCalculation': additionalCalculation,
      ...additionalData,
    };
  }
}

class OrderContactDetails {
  final String? name;
  final String? phone;
  final String? address;
  final String? countryId;
  final String? governorateId;
  final String? cityId;
  final double? latitude;
  final double? longitude;
  final String? email;
  final String? notes;

  OrderContactDetails({
    this.name,
    this.phone,
    this.address,
    this.countryId,
    this.governorateId,
    this.cityId,
    this.latitude,
    this.longitude,
    this.email,
    this.notes,
  });

  factory OrderContactDetails.fromJson(Map<String, dynamic> json) {
    return OrderContactDetails(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      countryId: json['countryId'] as String?,
      governorateId: json['governorateId'] as String?,
      cityId: json['cityId'] as String?,
      latitude: TypeParser.parseDouble(json['latitude']),
      longitude: TypeParser.parseDouble(json['longitude']),
      email: json['email'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'countryId': countryId,
      'governorateId': governorateId,
      'cityId': cityId,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
      'notes': notes,
    };
  }
}

class OrderItemData {
  final String id;
  final String? name;
  final String? description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final double? weight;
  final Map<String, double>? dimensions;

  OrderItemData({
    required this.id,
    this.name,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.weight,
    this.dimensions,
  });

  // Alias for backward compatibility
  String get productId => id;
  double get price => unitPrice;

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      id: (json['id'] ?? json['productId'] ?? '') as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
      quantity: TypeParser.parseInt(json['quantity'], 1),
      unitPrice: TypeParser.parseDouble(json['unitPrice'] ?? json['price']),
      totalPrice: TypeParser.parseDouble(json['totalPrice'] ??
          (TypeParser.parseDouble(json['unitPrice'] ?? json['price']) *
              TypeParser.parseInt(json['quantity'], 1))),
      weight: TypeParser.parseDouble(json['weight']),
      dimensions: json['dimensions'] is Map
          ? (json['dimensions'] as Map).map(
              (k, v) => MapEntry(k.toString(), TypeParser.parseDouble(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'weight': weight,
      'dimensions': dimensions,
    };
  }
}

class OrderWorkFlow {
  final LocalizedString? name;
  final LocalizedString? description;
  final int currentStepIndex;
  final OrderStepInfo? stepInfo;

  OrderWorkFlow({
    this.name,
    this.description,
    this.currentStepIndex = 0,
    this.stepInfo,
  });

  factory OrderWorkFlow.fromJson(Map<String, dynamic> json) {
    return OrderWorkFlow(
      name: json['name'] != null ? LocalizedString.fromJson(json['name']) : null,
      description: json['description'] != null
          ? LocalizedString.fromJson(json['description'])
          : null,
      currentStepIndex:
          TypeParser.parseInt(json['currentStepIndex'] ?? json['currentStep']),
      stepInfo: json['stepInfo'] != null
          ? OrderStepInfo.fromJson(json['stepInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name?.toJson(),
      'description': description?.toJson(),
      'currentStepIndex': currentStepIndex,
      'stepInfo': stepInfo?.toJson(),
    };
  }
}

class OrderStepInfo {
  final String stepKey;
  final LocalizedString? stepName;
  final String? stepColor;
  final bool ableToEditOrderItems;
  final String selectionMode;
  final String? assignedUserId;
  final bool isConsensusStep;
  final List<String> executorRoles;
  final List<WorkflowActionData> actions;

  OrderStepInfo({
    required this.stepKey,
    this.stepName,
    this.stepColor,
    this.ableToEditOrderItems = false,
    this.selectionMode = '',
    this.assignedUserId,
    this.isConsensusStep = false,
    this.executorRoles = const [],
    this.actions = const [],
  });

  factory OrderStepInfo.fromJson(Map<String, dynamic> json) {
    return OrderStepInfo(
      stepKey: (json['stepKey'] ?? '').toString(),
      stepName: json['stepName'] != null
          ? LocalizedString.fromJson(json['stepName'])
          : null,
      stepColor: json['stepColor'] as String?,
      ableToEditOrderItems: json['ableToEditOrderItems'] == true,
      selectionMode: json['selectionMode']?.toString() ?? '',
      assignedUserId: json['assignedUserId']?.toString(),
      isConsensusStep: json['isConsensusStep'] == true,
      executorRoles: (json['executorRoles'] as List?)?.cast<String>() ?? [],
      actions: (json['actions'] as List? ?? json['action'] as List?)
              ?.map((e) => WorkflowActionData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepKey': stepKey,
      'stepName': stepName?.toJson(),
      'stepColor': stepColor,
      'ableToEditOrderItems': ableToEditOrderItems,
      'selectionMode': selectionMode,
      'assignedUserId': assignedUserId,
      'isConsensusStep': isConsensusStep,
      'executorRoles': executorRoles,
      'actions': actions.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkflowActionData {
  final String actionName;
  final LocalizedString displayName;
  final int? targetStepNumber;
  final String? actionColor;

  WorkflowActionData({
    required this.actionName,
    required this.displayName,
    this.targetStepNumber,
    this.actionColor,
  });

  factory WorkflowActionData.fromJson(Map<String, dynamic> json) {
    // Ensure actionName is a technical key (string), not a localized object
    String name = '';
    if (json['actionKey'] != null) {
      name = json['actionKey'].toString();
    } else if (json['actionName'] is String) {
      name = json['actionName'].toString();
    } else if (json['_id'] != null) {
      name = json['_id'].toString();
    }

    return WorkflowActionData(
      actionName: name,
      displayName: json['displayName'] != null
          ? LocalizedString.fromJson(json['displayName'])
          : (json['actionName'] != null
              ? LocalizedString.fromJson(json['actionName'])
              : LocalizedString({'ar': '', 'en': ''})),
      targetStepNumber: TypeParser.parseInt(
          json['targetStepNumber'] ?? json['actionReturnToStepIndex']),
      actionColor: json['actionColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionName': actionName,
      'displayName': displayName.toJson(),
      'targetStepNumber': targetStepNumber,
      'actionColor': actionColor,
    };
  }
}
