import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:matger_pro_core_logic/utls/type_parser.dart';
import 'package:matger_pro_core_logic/models/entity_meta.dart';
import 'package:matger_pro_core_logic/models/localized_string.dart';

enum OfferTargetType { product, category }

class OfferData {
  final String id;
  final LocalizedString name;
  final LocalizedString description;
  final String organizationId;
  final String? imageUrl;
  final OfferTargetType targetType;
  final String targetId;
  final String? targetName;
  final double discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isValid;
  final bool isActive;
  final int sortOrder;
  final EntityMeta? meta;

  OfferData({
    required this.id,
    required this.name,
    required this.description,
    required this.organizationId,
    this.imageUrl,
    required this.targetType,
    required this.targetId,
    this.targetName,
    this.discountPercentage = 0,
    this.startDate,
    this.endDate,
    this.isValid = true,
    this.isActive = true,
    this.sortOrder = 0,
    this.meta,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      name: LocalizedString.fromJson(json['name']),
      description: LocalizedString.fromJson(json['description']),
      organizationId: (json['organizationId'] as String? ?? ''),
      imageUrl: json['imageUrl'] != null
          ? (json['imageUrl'].toString().contains('http')
                ? json['imageUrl'].toString()
                : ApiUrls.IMAGE_BASE_URL + json['imageUrl'].toString())
          : null,
      targetType: json['targetType'] == 'product'
          ? OfferTargetType.product
          : OfferTargetType.category,
      targetId: (json['targetId'] as String? ?? ''),
      targetName: json['targetName'] as String?,
      discountPercentage: TypeParser.parseDouble(json['discountPercentage']),
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      isValid: TypeParser.parseBool(json['isValid'], true),
      isActive: TypeParser.parseBool(json['isActive'], true),
      sortOrder: TypeParser.parseInt(json['sortOrder']),
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'description': description.toJson(),
      'organizationId': organizationId,
      'imageUrl': imageUrl,
      'targetType': targetType.name,
      'targetId': targetId,
      'targetName': targetName,
      'discountPercentage': discountPercentage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isValid': isValid,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'meta': meta?.toJson(),
    };
  }

  OfferData copyWith({
    String? id,
    LocalizedString? name,
    LocalizedString? description,
    String? organizationId,
    String? imageUrl,
    OfferTargetType? targetType,
    String? targetId,
    String? targetName,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isValid,
    bool? isActive,
    int? sortOrder,
    EntityMeta? meta,
  }) {
    return OfferData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      organizationId: organizationId ?? this.organizationId,
      imageUrl: imageUrl ?? this.imageUrl,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      targetName: targetName ?? this.targetName,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isValid: isValid ?? this.isValid,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      meta: meta ?? this.meta,
    );
  }

  @override
  String toString() {
    return 'OfferData(id: $id, name: ${name.ar}, targetType: ${targetType.name}, isActive: $isActive)';
  }
}
