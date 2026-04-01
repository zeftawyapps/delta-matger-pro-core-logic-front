import 'package:matger_core_logic/models/entity_meta.dart';
import 'package:matger_core_logic/utls/type_parser.dart';

class OrderData {
  final String orderId;
  final String organizationId;
  final String? customerId;
  final double totalAmount;
  final String status;
  final List<OrderItemData> items;
  final Map<String, dynamic> additionalData;
  final EntityMeta? meta;

  OrderData({
    required this.orderId,
    required this.organizationId,
    this.customerId,
    required this.totalAmount,
    this.status = 'pending',
    this.items = const [],
    this.additionalData = const {},
    this.meta,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final coreFields = [
      'orderId',
      'id',
      'organizationId',
      'shopId',
      'customerId',
      'userId',
      'totalAmount',
      'totalPrice',
      'status',
      'items',
      'meta',
    ];

    final additional = Map<String, dynamic>.from(json)
      ..removeWhere((key, value) => coreFields.contains(key));

    return OrderData(
      orderId: (json['orderId'] ?? json['id'] ?? '') as String,
      organizationId:
          (json['organizationId'] ?? json['shopId'] ?? '') as String,
      customerId: (json['customerId'] ?? json['userId']) as String?,
      totalAmount: TypeParser.parseDouble(json['totalAmount'] ?? json['totalPrice']),
      status: (json['status'] as String? ?? 'pending'),
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      additionalData: additional,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': orderId,
      'organizationId': organizationId,
      'customerId': customerId,
      'totalAmount': totalAmount,
      'status': status,
      'items': items.map((e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
      ...additionalData,
    };
  }
}

class OrderItemData {
  final String productId;
  final String? name;
  final int quantity;
  final double price;

  OrderItemData({
    required this.productId,
    this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      productId: (json['productId'] ?? '') as String,
      name: json['name'] as String?,
      quantity: TypeParser.parseInt(json['quantity'], 1),
      price: TypeParser.parseDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
