import '../data/product_model.dart';

/// Request body for bulk creating products
class BulkCreateProductsRequest {
  final String organizationId;
  final List<ProductData> products;

  BulkCreateProductsRequest({
    required this.organizationId,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

/// Request body for bulk updating specific fields in multiple products
class BulkUpdateProductsRequest {
  final String organizationId;
  final List<String> productIds;
  final Map<String, dynamic> updateData;

  BulkUpdateProductsRequest({
    required this.organizationId,
    required this.productIds,
    required this.updateData,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'productIds': productIds,
      'updateData': updateData,
    };
  }
}

/// Request body for bulk deleting products
class BulkDeleteProductsRequest {
  final String organizationId;
  final List<String> productIds;

  BulkDeleteProductsRequest({
    required this.organizationId,
    required this.productIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'productIds': productIds,
    };
  }
}

/// Request body for creating multiple variants from a template
class BulkVariantsRequest {
  final String organizationId;
  final List<dynamic> variantNames;
  final Map<String, dynamic> template;

  BulkVariantsRequest({
    required this.organizationId,
    required this.variantNames,
    required this.template,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'variantNames': variantNames,
      ...template,
    };
  }
}

/// Request body for shared pricing (Preview & Apply)
class SharedPricingRequest {
  final String organizationId;
  final List<String> productIds;
  final List<PriceOption> priceOptions;
  final double? basePrice;
  final String mode; // 'replace' or 'merge'

  SharedPricingRequest({
    required this.organizationId,
    required this.productIds,
    required this.priceOptions,
    this.basePrice,
    this.mode = 'replace',
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'productIds': productIds,
      'priceOptions': priceOptions.map((e) => e.toJson()).toList(),
      if (basePrice != null) 'basePrice': basePrice,
      'mode': mode,
    };
  }
}

/// Request body for linking an agent product to a master product
class LinkAgentProductRequest {
  final double price;
  final int stockQuantity;

  LinkAgentProductRequest({
    required this.price,
    this.stockQuantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'stockQuantity': stockQuantity,
    };
  }
}
