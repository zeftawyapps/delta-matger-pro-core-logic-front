import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:matger_core_logic/utls/type_parser.dart';
import 'package:matger_core_logic/models/entity_meta.dart';

class CategoryData {
  final String categoryId;
  final String name;
  final String organizationId;
  final EntityMeta? meta;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final int? displayOrder;
  final int? productCount;

  CategoryData({
    required this.categoryId,
    required this.name,
    required this.organizationId,
    this.meta,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.displayOrder,
    this.productCount,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      categoryId: json['categoryId'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      meta: json['meta'] != null
          ? EntityMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] != null
          ? ApiUrls.IMAGE_BASE_URL + json['imageUrl']
          : null,
      isActive: TypeParser.parseBool(json['isActive'], true),
      displayOrder: TypeParser.parseInt(json['displayOrder']),
      productCount: TypeParser.parseInt(json['productCount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'organizationId': organizationId,
      'meta': meta?.toJson(),
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'productCount': productCount,
    };
  }

  CategoryData copyWith({
    String? categoryId,
    String? name,
    String? organizationId,
    EntityMeta? meta,
    String? description,
    String? imageUrl,
    bool? isActive,
    int? displayOrder,
    int? productCount,
  }) {
    return CategoryData(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      organizationId: organizationId ?? this.organizationId,
      meta: meta ?? this.meta,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  String toString() {
    return 'CategoryData(categoryId: $categoryId, name: $name, organizationId: $organizationId, isActive: $isActive, productCount: $productCount)';
  }
}
