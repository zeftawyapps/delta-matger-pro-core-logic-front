import 'package:matger_core_logic/features/commrec/data/product_model.dart';
import 'package:matger_core_logic/features/commrec/source/product_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'dart:io';

class ProductRepo {
  late final ProductSource _productSource;

  ProductRepo({ProductSource? productSource}) {
    _productSource = productSource ?? ProductSource();
  }

  Future<RemoteBaseModel<ProductData>> createProduct({
    required String name,
    required String categoryId,
    required String shopId,
    required double price,
    List<File>? images,
  }) async {
    JDRepoConsole.info("Creating product in repo: $name",
        context: LogContext(module: "ProductRepo", method: "createProduct"));
    final result = await _productSource.createProduct(
      name: name,
      categoryId: categoryId,
      shopId: shopId,
      price: price,
      images: images,
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
      final product = ProductData.fromJson(result.data as Map<String, dynamic>);
      JDRepoConsole.success("Product parsed successfully in repo",
          context: LogContext(module: "ProductRepo", method: "createProduct"));
      return RemoteBaseModel(
        data: product,
        status: StatusModel.success,
      );
    } catch (e) {
      JDRepoConsole.error("Parsing error in createProduct: $e",
          context: LogContext(module: "ProductRepo", method: "createProduct", metadata: result.data));
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
      JDRepoConsole.error("Source error in getProducts: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "getProducts"));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List productsList;

      if (data is List) {
        productsList = data;
      } else if (data is Map) {
        if (data['products'] is List) {
          productsList = data['products'];
        } else if (data['data'] is List) {
          productsList = data['data'];
        } else if (data['data'] is Map && data['data']['products'] is List) {
          productsList = data['data']['products'];
        } else {
          productsList = [];
        }
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
          context: LogContext(module: "ProductRepo", method: "getProducts", metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<List<ProductData>>> searchProducts({
    required String name,
    required String shopId,
  }) async {
    JDRepoConsole.info("Searching products in repo: $name",
        context: LogContext(module: "ProductRepo", method: "searchProducts"));
    final result = await _productSource.searchProducts(
      name: name,
      shopId: shopId,
    );

    if (result.error != null) {
      JDRepoConsole.error("Source error in searchProducts: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "searchProducts"));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List productsList;

      if (data is List) {
        productsList = data;
      } else if (data is Map) {
        if (data['products'] is List) {
          productsList = data['products'];
        } else if (data['data'] is List) {
          productsList = data['data'];
        } else if (data['data'] is Map && data['data']['products'] is List) {
          productsList = data['data']['products'];
        } else {
          productsList = [];
        }
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
          context: LogContext(module: "ProductRepo", method: "searchProducts", metadata: result.data));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "Parsing Error: $e",
      );
    }
  }

  Future<RemoteBaseModel<ProductData>> updateProduct({
    required String productId,
    required String name,
    required String categoryId,
    required double price,
  }) async {
    JDRepoConsole.info("Updating product in repo: $productId",
        context: LogContext(module: "ProductRepo", method: "updateProduct"));
    final result = await _productSource.updateProduct(
      productId: productId,
      name: name,
      categoryId: categoryId,
      price: price,
    );

    if (result.error != null) {
      JDRepoConsole.error("Source error in updateProduct: ${result.error?.message}",
          context: LogContext(module: "ProductRepo", method: "updateProduct"));
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final product = ProductData.fromJson(result.data as Map<String, dynamic>);
      JDRepoConsole.success("Product updated and parsed successfully in repo",
          context: LogContext(module: "ProductRepo", method: "updateProduct"));
      return RemoteBaseModel(
        data: product,
        status: StatusModel.success,
      );
    } catch (e) {
      JDRepoConsole.error("Parsing error in updateProduct: $e",
          context: LogContext(module: "ProductRepo", method: "updateProduct", metadata: result.data));
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
