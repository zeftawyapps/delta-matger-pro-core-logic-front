import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:matger_pro_core_logic/utls/type_parser.dart';
import 'package:matger_pro_core_logic/models/entity_meta.dart';
import 'package:matger_pro_core_logic/models/localized_string.dart';

/// وحدة المنتج (Product Unit)
enum ProductUnit {
  ml,
  liter,
  galon,
  gram,
  kg,
  piece,
  bottle,
  jar,
  pack,
  box,
  sachet,
  mm,
  custom,
}

/// خيارات السعر (مثل الأحجام المختلفة للمنتج)
class PriceOption {
  final double quantity;
  final String unit;
  final double price;
  final double? oldPrice;
  final bool isDefault;
  final LocalizedString? sizeDisplay;

  PriceOption({
    required this.quantity,
    required this.unit,
    required this.price,
    this.oldPrice,
    this.isDefault = false,
    this.sizeDisplay,
  });

  factory PriceOption.fromJson(Map<String, dynamic> json) {
    return PriceOption(
      quantity: TypeParser.parseDouble(json['quantity']),
      unit: json['unit'] as String? ?? '',
      price: TypeParser.parseDouble(json['price']),
      oldPrice: json['oldPrice'] != null
          ? TypeParser.parseDouble(json['oldPrice'])
          : null,
      isDefault: TypeParser.parseBool(json['isDefault']),
      sizeDisplay: json['sizeDisplay'] != null
          ? LocalizedString.fromJson(json['sizeDisplay'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'oldPrice': oldPrice,
      'isDefault': isDefault,
    };
    if (sizeDisplay != null) {
      map['sizeDisplay'] = sizeDisplay!.toJson();
    }
    return map;
  }
}

class ProductData {
  final String id;
  final LocalizedString name;
  final String categoryId;
  final String organizationId;
  final double price;
  final double? oldPrice;
  final double? cost;
  final List<String> images;
  final bool isActive;
  final int stockQuantity;
  final bool isNew;
  final bool isBestSeller;
  final bool isAvailable;
  final double? discount;
  final double rating;
  final List<PriceOption> priceOptions;
  final bool isJoker;
  final bool isSuperJoker;
  final bool isOnSale;
  final Map<String, dynamic> additionalData;
  final EntityMeta? meta;
  final DateTime? createdAt;

  ProductData({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.organizationId,
    required this.price,
    this.oldPrice,
    this.cost,
    this.images = const [],
    this.isActive = true,
    this.stockQuantity = 0,
    this.isNew = false,
    this.isBestSeller = false,
    this.isAvailable = true,
    this.discount,
    this.rating = 0.0,
    this.priceOptions = const [],
    this.isJoker = false,
    this.isSuperJoker = false,
    this.isOnSale = false,
    this.additionalData = const {},
    this.meta,
    this.createdAt,
  });

  // Alias for backward compatibility
  String get productId => id;

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final coreFields = [
      'id',
      'productId',
      '_id',
      'name',
      'categoryId',
      'category',
      'organizationId',
      'price',
      'oldPrice',
      'cost',
      'imageUrls',
      'images',
      'image',
      'isActive',
      'stockQuantity',
      'isNew',
      'isBestSeller',
      'isAvailable',
      'discount',
      'rating',
      'priceOptions',
      'isJoker',
      'isSuperJoker',
      'isOnSale',
      'meta',
      'createdAt',
      'updatedAt',
    ];

    final additional = Map<String, dynamic>.from(json)
      ..removeWhere((key, value) => coreFields.contains(key));

    return ProductData(
      id: (json['id'] ?? json['productId'] ?? json['_id'] ?? '') as String,
      name: LocalizedString.fromJson(json['name']),
      categoryId: (json['categoryId'] ?? json['category'] ?? '') as String,
      organizationId: (json['organizationId'] as String? ?? ''),
      price: TypeParser.parseDouble(json['price']),
      oldPrice: json['oldPrice'] != null
          ? TypeParser.parseDouble(json['oldPrice'])
          : null,
      cost: json['cost'] != null ? TypeParser.parseDouble(json['cost']) : null,
      images:
          (json['images'] as List?)
              ?.map(
                (e) => e.toString().contains('http')
                    ? e.toString()
                    : ApiUrls.IMAGE_BASE_URL + e.toString(),
              )
              .toList() ??
          (json['imageUrls'] as List?)
              ?.map(
                (e) => e.toString().contains('http')
                    ? e.toString()
                    : ApiUrls.IMAGE_BASE_URL + e.toString(),
              )
              .toList() ??
          [],
      isActive: TypeParser.parseBool(json['isActive'], true),
      stockQuantity: TypeParser.parseInt(json['stockQuantity']),
      isNew: TypeParser.parseBool(json['isNew']),
      isBestSeller: TypeParser.parseBool(json['isBestSeller']),
      isAvailable: TypeParser.parseBool(json['isAvailable'], true),
      discount: json['discount'] != null
          ? TypeParser.parseDouble(json['discount'])
          : null,
      rating: TypeParser.parseDouble(json['rating']),
      priceOptions:
          (json['priceOptions'] as List?)
              ?.map((e) => PriceOption.fromJson(e))
              .toList() ??
          [],
      isJoker: TypeParser.parseBool(json['isJoker']),
      isSuperJoker: TypeParser.parseBool(json['isSuperJoker']),
      isOnSale: TypeParser.parseBool(json['isOnSale']),
      additionalData:
          json['additionalData'] as Map<String, dynamic>? ?? additional,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': id, // Added for backend compatibility in bulk operations
      'name': name.toJson(),
      'categoryId': categoryId,
      'organizationId': organizationId,
      'price': price,
      'oldPrice': oldPrice,
      'cost': cost,
      'images': images,
      'isActive': isActive,
      'stockQuantity': stockQuantity,
      'isNew': isNew,
      'isBestSeller': isBestSeller,
      'isAvailable': isAvailable,
      'discount': discount,
      'rating': rating,
      'priceOptions': priceOptions.map((e) => e.toJson()).toList(),
      'isJoker': isJoker,
      'isSuperJoker': isSuperJoker,
      'isOnSale': isOnSale,
      'additionalData': additionalData,
      'meta': meta?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // --- دوال مساعدة (Helper Methods) للفرونت اند ---

  /// الحصول على الصورة الأساسية
  String get mainImage =>
      images.isNotEmpty ? images.first : 'assets/placeholder.png';

  /// حساب السعر النهائي بعد الخصم
  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price - (price * discount! / 100);
    }
    return price;
  }

  /// هل يوجد خصم حالي؟
  bool get hasDiscount =>
      (discount != null && discount! > 0) ||
      (oldPrice != null && oldPrice! > price);

  /// الحصول على أقل سعر متاح (في حال وجود أحجام مختلفة)
  double get minPrice {
    if (priceOptions.isEmpty) return price;
    return priceOptions.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  }

  /// هل المنتج متوفر في المخزن؟
  bool get isInStock => isAvailable && stockQuantity > 0;

  /// Localized description from additionalData
  LocalizedString get description {
    if (additionalData['description'] != null) {
      return LocalizedString.fromJson(additionalData['description']);
    }
    return name;
  }
}
