import 'package:matger_pro_core_logic/models/entity_meta.dart';

enum OrderStatus {
  pending,
  accepted,
  pickedUp,
  inTransit,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'in_transit':
        return OrderStatus.inTransit;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

class ContactDetails {
  final String name;
  final String phone;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? email;
  final String? notes;

  ContactDetails({
    required this.name,
    required this.phone,
    required this.address,
    this.latitude,
    this.longitude,
    this.email,
    this.notes,
  });

  factory ContactDetails.fromJson(Map<String, dynamic> json) {
    return ContactDetails(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      email: json['email'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
      'notes': notes,
    };
  }
}

class OrderItemShort {
  final String id;
  final String name;
  final String? description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final double? weight;

  OrderItemShort({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.description,
    this.weight,
  });

  factory OrderItemShort.fromJson(Map<String, dynamic> json) {
    return OrderItemShort(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      quantity: (json['quantity'] as num? ?? 1).toInt(),
      unitPrice: (json['unitPrice'] as num? ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] as num? ?? 0.0).toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
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
    };
  }
}

class OrderModel {
  final String id;
  final String organizationId;
  final String? driverId;
  final ContactDetails senderDetails;
  final ContactDetails recipientDetails;
  final List<OrderItemShort> items;
  final double totalOrderPrice;
  final String? workflowName;
  final int? currentStepIndex;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final EntityMeta? meta;

  OrderModel({
    required this.id,
    required this.organizationId,
    required this.senderDetails,
    required this.recipientDetails,
    required this.items,
    required this.totalOrderPrice,
    required this.createdAt,
    this.driverId,
    this.workflowName,
    this.currentStepIndex,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.meta,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: (json['id'] ?? json['orderId'] ?? '') as String,
      organizationId: json['organizationId'] as String? ?? '',
      driverId: json['driverId'] as String?,
      senderDetails: ContactDetails.fromJson(
        json['senderDetails'] as Map<String, dynamic>? ?? {},
      ),
      recipientDetails: ContactDetails.fromJson(
        json['recipientDetails'] as Map<String, dynamic>? ?? {},
      ),
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItemShort.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalOrderPrice: (json['totalOrderPrice'] as num? ?? 0.0).toDouble(),
      workflowName: json['workflowName'] as String?,
      currentStepIndex: (json['currentStepIndex'] as num?)?.toInt(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'].toString())
          : null,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.tryParse(json['pickedUpAt'].toString())
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'].toString())
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.tryParse(json['cancelledAt'].toString())
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'driverId': driverId,
      'senderDetails': senderDetails.toJson(),
      'recipientDetails': recipientDetails.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'totalOrderPrice': totalOrderPrice,
      'workflowName': workflowName,
      'currentStepIndex': currentStepIndex,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'meta': meta?.toJson(),
    };
  }
}
