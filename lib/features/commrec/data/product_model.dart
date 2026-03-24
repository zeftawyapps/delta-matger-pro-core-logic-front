import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:matger_core_logic/models/entity_meta.dart';

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

/// كائن للتعامل مع النصوص المترجمة (Localized Strings)
class LocalizedString {
  final Map<String, String> values;

  LocalizedString(this.values);

  factory LocalizedString.fromJson(dynamic json) {
    if (json is String) return LocalizedString({'ar': json, 'en': json});
    if (json is Map) {
      return LocalizedString(Map<String, String>.from(json));
    }
    return LocalizedString({'ar': '', 'en': ''});
  }

  String get(String lang) => values[lang] ?? values['ar'] ?? values['en'] ?? '';

  // للحصول على النص العربي تلقائياً
  String get ar => get('ar');
  String get en => get('en');

  Map<String, dynamic> toJson() => values;
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
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      unit: json['unit'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      isDefault: json['isDefault'] ?? false,
      sizeDisplay: json['sizeDisplay'] != null
          ? LocalizedString.fromJson(json['sizeDisplay'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'unit': unit,
    'price': price,
    'oldPrice': oldPrice,
    'isDefault': isDefault,
    'sizeDisplay': sizeDisplay?.toJson(),
  };
}

class ProductData {
  final String productId;
  final LocalizedString name;
  final String categoryId;
  final String organizationId;
  final double price;
  final double? oldPrice;
  final double? cost;
  final List<String> imageUrls;
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
    required this.productId,
    required this.name,
    required this.categoryId,
    required this.organizationId,
    required this.price,
    this.oldPrice,
    this.cost,
    this.imageUrls = const [],
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
      productId:
          (json['id'] ?? json['productId'] ?? json['_id'] ?? '') as String,
      name: LocalizedString.fromJson(json['name']),
      categoryId: (json['categoryId'] ?? json['category'] ?? '') as String,
      organizationId: (json['organizationId'] as String? ?? ''),
      price: (json['price'] as num? ?? 0.0).toDouble(),
      oldPrice: (json['oldPrice'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      imageUrls:
          (json['imageUrls'] as List?)
              ?.map(
                (e) => e.toString().contains('http')
                    ? e.toString()
                    : ApiUrls.IMAGE_BASE_URL + e.toString(),
              )
              .toList() ??
          (json['images'] as List?)
              ?.map(
                (e) => e.toString().contains('http')
                    ? e.toString()
                    : ApiUrls.IMAGE_BASE_URL + e.toString(),
              )
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
      stockQuantity: (json['stockQuantity'] as num? ?? 0).toInt(),
      isNew: json['isNew'] as bool? ?? false,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      isAvailable: json['isAvailable'] as bool? ?? true,
      discount: (json['discount'] as num?)?.toDouble(),
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      priceOptions:
          (json['priceOptions'] as List?)
              ?.map((e) => PriceOption.fromJson(e))
              .toList() ??
          [],
      isJoker: json['isJoker'] as bool? ?? false,
      isSuperJoker: json['isSuperJoker'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
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
      'productId': productId,
      'name': name.toJson(),
      'categoryId': categoryId,
      'organizationId': organizationId,
      'price': price,
      'oldPrice': oldPrice,
      'cost': cost,
      'imageUrls': imageUrls,
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
      imageUrls.isNotEmpty ? imageUrls.first : 'assets/placeholder.png';

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

  /// Flattened description for easier access
  String get description =>
      (additionalData['description'] ?? name.ar).toString();
}
