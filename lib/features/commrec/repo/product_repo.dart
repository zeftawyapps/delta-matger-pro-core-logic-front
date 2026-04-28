import 'package:matger_pro_core_logic/features/commrec/data/product_model.dart';
import 'package:matger_pro_core_logic/features/commrec/source/product_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_pro_core_logic/features/commrec/request_body/product_request_bodies.dart';
import 'dart:typed_data';

class ProductRepo {
  late final ProductSource _productSource;

  ProductRepo({ProductSource? productSource}) {
    _productSource = productSource ?? ProductSource();
  }

  Future<RemoteBaseModel<ProductData>> createProduct({
    required dynamic name,
    required String categoryId,
    required String organizationId,
    required double price,
    Uint8List? imageBytes,
    String? imageName,
    Map<String, dynamic>? additionalData,
    bool isNew = false,
    bool isBestSeller = false,
    bool isOnSale = false,
    bool isJoker = false,
    bool isSuperJoker = false,
    bool isAvailable = true,
    double? oldPrice,
    double? discount,
    List<PriceOption>? priceOptions,
  }) async {
    JDRepoConsole.info(
      "Creating product in repo: $name",
      context: LogContext(module: "ProductRepo", method: "createProduct"),
    );
    final result = await _productSource.createProduct(
      name: name,
      categoryId: categoryId,
      organizationId: organizationId,
      price: price,
      imageBytes: imageBytes,
      imageName: imageName,
      additionalData: additionalData,
      isNew: isNew,
      isBestSeller: isBestSeller,
      isOnSale: isOnSale,
      isJoker: isJoker,
      isSuperJoker: isSuperJoker,
      isAvailable: isAvailable,
      oldPrice: oldPrice,
      discount: discount,
      priceOptions: priceOptions?.map((e) => e.toJson()).toList(),
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createProduct: ${result.error?.message}",
        context: LogContext(module: "ProductRepo", method: "createProduct"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final data = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final product = ProductData.fromJson(data);
      JDRepoConsole.success(
        "Product parsed successfully in repo",
        context: LogContext(module: "ProductRepo", method: "createProduct"),
      );
      return RemoteBaseModel(data: product, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createProduct: $e",
        context: LogContext(
          module: "ProductRepo",
          method: "createProduct",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة بيانات المنتج",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    JDRepoConsole.info(
      "Getting products in repo - page: $page",
      context: LogContext(module: "ProductRepo", method: "getProducts"),
    );
    final result = await _productSource.getProducts(page: page, limit: limit);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getProducts: ${result.error?.message}",
        context: LogContext(module: "ProductRepo", method: "getProducts"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List productsList;

      if (rawData is List) {
        productsList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : (rawData.containsKey('data') &&
                  rawData['data'] is Map &&
                  rawData['data']['products'] is List)
            ? rawData['data']['products'] as List
            : [];
        productsList = data;
      } else {
        productsList = [];
      }

      final products = productsList
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${products.length} products successfully",
        context: LogContext(module: "ProductRepo", method: "getProducts"),
      );
      return RemoteBaseModel(data: products, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getProducts: $e",
        context: LogContext(
          module: "ProductRepo",
          method: "getProducts",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في عرض المنتجات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> searchProducts({
    required String name,
    required String organizationId,
  }) async {
    JDRepoConsole.info(
      "Searching products in repo: $name",
      context: LogContext(module: "ProductRepo", method: "searchProducts"),
    );
    final result = await _productSource.searchProducts(
      name: name,
      organizationId: organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in searchProducts: ${result.error?.message}",
        context: LogContext(module: "ProductRepo", method: "searchProducts"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List productsList;

      if (rawData is List) {
        productsList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : (rawData.containsKey('data') &&
                  rawData['data'] is Map &&
                  rawData['data']['products'] is List)
            ? rawData['data']['products'] as List
            : [];
        productsList = data;
      } else {
        productsList = [];
      }

      final products = productsList
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Search returned ${products.length} products successfully",
        context: LogContext(module: "ProductRepo", method: "searchProducts"),
      );
      return RemoteBaseModel(data: products, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in searchProducts: $e",
        context: LogContext(
          module: "ProductRepo",
          method: "searchProducts",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في البحث عن المنتجات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    JDRepoConsole.info(
      "Getting products by category in repo: $categoryId - page: $page",
      context:
          LogContext(module: "ProductRepo", method: "getProductsByCategory"),
    );
    final result = await _productSource.getProductsByCategory(
      categoryId: categoryId,
      page: page,
      limit: limit,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getProductsByCategory: ${result.error?.message}",
        context:
            LogContext(module: "ProductRepo", method: "getProductsByCategory"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List productsList;

      if (rawData is List) {
        productsList = rawData;
      } else if (rawData is Map) {
        final data = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : (rawData.containsKey('data') &&
                  rawData['data'] is Map &&
                  rawData['data']['products'] is List)
            ? rawData['data']['products'] as List
            : [];
        productsList = data;
      } else {
        productsList = [];
      }

      final products = productsList
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${products.length} products successfully for category: $categoryId",
        context:
            LogContext(module: "ProductRepo", method: "getProductsByCategory"),
      );
      return RemoteBaseModel(data: products, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getProductsByCategory: $e",
        context: LogContext(
          module: "ProductRepo",
          method: "getProductsByCategory",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في عرض منتجات القسم",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<ProductData>> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info(
      "Updating product in repo: $productId",
      context: LogContext(module: "ProductRepo", method: "updateProduct"),
    );
    final result = await _productSource.updateProduct(
      productId: productId,
      data: data,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateProduct: ${result.error?.message}",
        context: LogContext(module: "ProductRepo", method: "updateProduct"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data as Map<String, dynamic>;
      final dataResult = (rawData.containsKey('data') && rawData['data'] is Map)
          ? rawData['data'] as Map<String, dynamic>
          : rawData;
      final product = ProductData.fromJson(dataResult);
      JDRepoConsole.success(
        "Product updated and parsed successfully in repo",
        context: LogContext(module: "ProductRepo", method: "updateProduct"),
      );
      return RemoteBaseModel(data: product, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in updateProduct: $e",
        context: LogContext(
          module: "ProductRepo",
          method: "updateProduct",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تحديث بيانات المنتج",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> deleteProduct(String productId) async {
    JDRepoConsole.info(
      "Deleting product in repo: $productId",
      context: LogContext(module: "ProductRepo", method: "deleteProduct"),
    );
    final result = await _productSource.deleteProduct(productId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in deleteProduct: ${result.error?.message}",
        context: LogContext(module: "ProductRepo", method: "deleteProduct"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      "Product deleted successfully in repo",
      context: LogContext(module: "ProductRepo", method: "deleteProduct"),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  // --- Bulk Operations ---

  Future<RemoteBaseModel<List<ProductData>>> bulkCreateProducts({
    required BulkCreateProductsRequest request,
  }) async {
    JDRepoConsole.info(
      "Bulk creating ${request.products.length} products in repo",
      context: LogContext(module: "ProductRepo", method: "bulkCreateProducts"),
    );
    final result = await _productSource.bulkCreateProducts(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List list;

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map) {
        list = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : [];
      } else {
        list = [];
      }

      final productsList = list
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: productsList, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في المعالجة الجماعية للمنتجات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> bulkUpdateProducts({
    required BulkUpdateProductsRequest request,
  }) async {
    JDRepoConsole.info(
      "Bulk updating ${request.productIds.length} products in repo",
      context: LogContext(module: "ProductRepo", method: "bulkUpdateProducts"),
    );
    final result = await _productSource.bulkUpdateProducts(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List list;

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map) {
        list = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : [];
      } else {
        list = [];
      }

      final productsList = list
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: productsList, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في التحديث الجماعي للمنتجات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> bulkDeleteProducts({
    required BulkDeleteProductsRequest request,
  }) async {
    JDRepoConsole.info(
      "Bulk deleting ${request.productIds.length} products in repo",
      context: LogContext(module: "ProductRepo", method: "bulkDeleteProducts"),
    );
    final result = await _productSource.bulkDeleteProducts(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<List<ProductData>>> bulkVariants({
    required BulkVariantsRequest request,
  }) async {
    JDRepoConsole.info(
      "Bulk creating variants in repo",
      context: LogContext(module: "ProductRepo", method: "bulkVariants"),
    );
    final result = await _productSource.bulkVariants(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final rawData = result.data;
      final List list;

      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map) {
        list = (rawData.containsKey('data') && rawData['data'] is List)
            ? rawData['data'] as List
            : (rawData.containsKey('products') && rawData['products'] is List)
            ? rawData['products'] as List
            : [];
      } else {
        list = [];
      }

      final productsList = list
          .map((e) => ProductData.fromJson(e as Map<String, dynamic>))
          .toList();
      return RemoteBaseModel(data: productsList, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في معالجة المتغيرات",
        data: null,
      );
    }
  }

  // --- Shared Pricing Tools ---

  Future<RemoteBaseModel<dynamic>> sharedPricingPreview({
    required SharedPricingRequest request,
  }) async {
    JDRepoConsole.info(
      "Shared pricing preview in repo",
      context: LogContext(
        module: "ProductRepo",
        method: "sharedPricingPreview",
      ),
    );
    final result = await _productSource.sharedPricingPreview(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    return RemoteBaseModel(data: result.data, status: StatusModel.success);
  }

  Future<RemoteBaseModel<bool>> sharedPricingApply({
    required SharedPricingRequest request,
  }) async {
    JDRepoConsole.info(
      "Shared pricing apply in repo",
      context: LogContext(module: "ProductRepo", method: "sharedPricingApply"),
    );
    final result = await _productSource.sharedPricingApply(request: request);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
