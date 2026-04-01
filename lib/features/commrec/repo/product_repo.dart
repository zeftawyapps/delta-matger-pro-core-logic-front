import 'package:matger_core_logic/features/commrec/data/product_model.dart';
import 'package:matger_core_logic/features/commrec/source/product_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
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
    JDRepoConsole.info("Creating product in repo: $name",
        context: LogContext(module: "ProductRepo", method: "createProduct"));
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
      JDRepoConsole.error("Source error in createProduct: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "createProduct"));
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
      JDRepoConsole.success("Product parsed successfully in repo",
          context: LogContext(module: "ProductRepo", method: "createProduct"));
      return RemoteBaseModel(
        data: product,
        status: StatusModel.success,
      );
    } catch (e) {
      JDRepoConsole.error("Parsing error in createProduct: $e",
          context: LogContext(
              module: "ProductRepo",
              method: "createProduct",
              metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    JDRepoConsole.info("Getting products in repo - page: $page",
        context: LogContext(module: "ProductRepo", method: "getProducts"));
    final result = await _productSource.getProducts(page: page, limit: limit);

    if (result.error != null) {
      JDRepoConsole.error(
          "Source error in getProducts: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "getProducts"));
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
      JDRepoConsole.success("Fetched ${products.length} products successfully",
          context: LogContext(module: "ProductRepo", method: "getProducts"));
      return RemoteBaseModel(data: products, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error("Parsing error in getProducts: $e",
          context: LogContext(
              module: "ProductRepo",
              method: "getProducts",
              metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> searchProducts({
    required String name,
    required String organizationId,
  }) async {
    JDRepoConsole.info("Searching products in repo: $name",
        context: LogContext(module: "ProductRepo", method: "searchProducts"));
    final result = await _productSource.searchProducts(
      name: name,
      organizationId: organizationId,
    );

    if (result.error != null) {
      JDRepoConsole.error(
          "Source error in searchProducts: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "searchProducts"));
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
      JDRepoConsole.success("Search returned ${products.length} products successfully",
          context: LogContext(module: "ProductRepo", method: "searchProducts"));
      return RemoteBaseModel(data: products, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error("Parsing error in searchProducts: $e",
          context: LogContext(
              module: "ProductRepo",
              method: "searchProducts",
              metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<ProductData>> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    JDRepoConsole.info("Updating product in repo: $productId",
        context: LogContext(module: "ProductRepo", method: "updateProduct"));
    final result = await _productSource.updateProduct(
      productId: productId,
      data: data,
      imageBytes: imageBytes,
      imageName: imageName,
    );

    if (result.error != null) {
      JDRepoConsole.error(
          "Source error in updateProduct: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "updateProduct"));
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
      JDRepoConsole.success("Product updated and parsed successfully in repo",
          context: LogContext(module: "ProductRepo", method: "updateProduct"));
      return RemoteBaseModel(
        data: product,
        status: StatusModel.success,
      );
    } catch (e) {
      JDRepoConsole.error("Parsing error in updateProduct: $e",
          context: LogContext(
              module: "ProductRepo",
              method: "updateProduct",
              metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<bool>> deleteProduct(String productId) async {
    JDRepoConsole.info("Deleting product in repo: $productId",
        context: LogContext(module: "ProductRepo", method: "deleteProduct"));
    final result = await _productSource.deleteProduct(productId);

    if (result.error != null) {
      JDRepoConsole.error("Source error in deleteProduct: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "deleteProduct"));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success("Product deleted successfully in repo",
        context: LogContext(module: "ProductRepo", method: "deleteProduct"));
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
