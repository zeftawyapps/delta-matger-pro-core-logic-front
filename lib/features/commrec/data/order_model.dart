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
      workFlow: json['workFlow'] != null
          ? OrderWorkFlow.fromJson(json['workFlow'])
          : null,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
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
      ...additionalData,
    };
  }
}

class OrderContactDetails {
  final String? name;
  final String? phone;
  final String? address;

  OrderContactDetails({this.name, this.phone, this.address});

  factory OrderContactDetails.fromJson(Map<String, dynamic> json) {
    return OrderContactDetails(
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'address': address};
  }
}

class OrderItemData {
  final String id;
  final String? name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItemData({
    required this.id,
    this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  // Alias for backward compatibility
  String get productId => id;
  double get price => unitPrice;

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      id: (json['id'] ?? json['productId'] ?? '') as String,
      name: json['name'] as String?,
      quantity: TypeParser.parseInt(json['quantity'], 1),
      unitPrice: TypeParser.parseDouble(json['unitPrice'] ?? json['price']),
      totalPrice: TypeParser.parseDouble(json['totalPrice'] ??
          (TypeParser.parseDouble(json['unitPrice'] ?? json['price']) *
              TypeParser.parseInt(json['quantity'], 1))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}

class OrderWorkFlow {
  final int currentStepIndex;
  final OrderStepInfo? stepInfo;

  OrderWorkFlow({this.currentStepIndex = 0, this.stepInfo});

  factory OrderWorkFlow.fromJson(Map<String, dynamic> json) {
    return OrderWorkFlow(
      currentStepIndex: TypeParser.parseInt(json['currentStepIndex']),
      stepInfo: json['stepInfo'] != null
          ? OrderStepInfo.fromJson(json['stepInfo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStepIndex': currentStepIndex,
      'stepInfo': stepInfo?.toJson(),
    };
  }
}

class OrderStepInfo {
  final String stepKey;
  final LocalizedString? stepName;

  OrderStepInfo({required this.stepKey, this.stepName});

  factory OrderStepInfo.fromJson(Map<String, dynamic> json) {
    return OrderStepInfo(
      stepKey: (json['stepKey'] ?? '').toString(),
      stepName: json['stepName'] != null
          ? LocalizedString.fromJson(json['stepName'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stepKey': stepKey,
      'stepName': stepName?.toJson(),
    };
  }
}
