import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'dart:io';

class ProductSource {
  ProductSource();

  Future<Result<RemoteBaseModel, dynamic>> createProduct({
    required String name,
    required String categoryId,
    required String shopId,
    required double price,
    List<File>? images,
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info("Creating product: $name",
          context: LogContext(module: "ProductSource", method: "createProduct"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.products}?trigger=$trigger";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: {
          "name": name,
          "categoryId": categoryId,
          "shopId": shopId,
          "price": price,
        },
        cancelToken: CancelToken(),
      );

      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Product created successfully",
            context: LogContext(module: "ProductSource", method: "createProduct"));
      } else {
        JDRepoConsole.error("Product creation failed",
            context: LogContext(
                module: "ProductSource",
                method: "createProduct",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error creating product: $e",
          context: LogContext(module: "ProductSource", method: "createProduct"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      JDRepoConsole.info("Fetching products - page: $page, limit: $limit",
          context: LogContext(module: "ProductSource", method: "getProducts"));
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.products}?page=$page&limit=$limit";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Products fetched successfully",
            context: LogContext(module: "ProductSource", method: "getProducts"));
      } else {
        JDRepoConsole.error("Failed to fetch products",
            context: LogContext(
                module: "ProductSource",
                method: "getProducts",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error fetching products: $e",
          context: LogContext(module: "ProductSource", method: "getProducts"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> searchProducts({
    required String name,
    required String shopId,
  }) async {
    try {
      JDRepoConsole.info("Searching products: $name in shop: $shopId",
          context: LogContext(module: "ProductSource", method: "searchProducts"));
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.searchProducts}?name=$name&shopId=$shopId";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Search completed successfully",
            context: LogContext(module: "ProductSource", method: "searchProducts"));
      } else {
        JDRepoConsole.error("Search failed",
            context: LogContext(
                module: "ProductSource",
                method: "searchProducts",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error searching products: $e",
          context: LogContext(module: "ProductSource", method: "searchProducts"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateStock({
    required String productId,
    required int quantity,
  }) async {
    try {
      JDRepoConsole.info("Updating stock for product: $productId to quantity: $quantity",
          context: LogContext(module: "ProductSource", method: "updateStock"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.updateStock(productId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST, // Using POST since PATCH is not in enum
        url: url,
        body: {"quantity": quantity},
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Stock updated successfully",
            context: LogContext(module: "ProductSource", method: "updateStock"));
      } else {
        JDRepoConsole.error("Stock update failed",
            context: LogContext(
                module: "ProductSource",
                method: "updateStock",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error updating stock: $e",
          context: LogContext(module: "ProductSource", method: "updateStock"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateProduct({
    required String productId,
    required String name,
    required String categoryId,
    required double price,
  }) async {
    try {
      JDRepoConsole.info("Updating product: $productId",
          context: LogContext(module: "ProductSource", method: "updateProduct"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.productById(productId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {"name": name, "categoryId": categoryId, "price": price},
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Product updated successfully",
            context: LogContext(module: "ProductSource", method: "updateProduct"));
      } else {
        JDRepoConsole.error("Product update failed",
            context: LogContext(
                module: "ProductSource",
                method: "updateProduct",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error updating product: $e",
          context: LogContext(module: "ProductSource", method: "updateProduct"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteProduct(
    String productId,
  ) async {
    try {
      JDRepoConsole.info("Deleting product: $productId",
          context: LogContext(module: "ProductSource", method: "deleteProduct"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.productById(productId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Product deleted successfully",
            context: LogContext(module: "ProductSource", method: "deleteProduct"));
      } else {
        JDRepoConsole.error("Product deletion failed",
            context: LogContext(
                module: "ProductSource",
                method: "deleteProduct",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error deleting product: $e",
          context: LogContext(module: "ProductSource", method: "deleteProduct"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Result<RemoteBaseModel, dynamic> _handleResult(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }
    return Result.error(
      RemoteBaseModel(
        message: result.error?.message ?? result.data?.message,
        status: result.data?.status ?? StatusModel.error,
      ),
    );
  }
}
