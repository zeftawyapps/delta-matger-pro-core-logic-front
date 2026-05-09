import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'package:matger_pro_core_logic/features/commrec/request_body/product_request_bodies.dart';
import 'dart:typed_data';

class ProductSource {
  ProductSource();

  Future<Result<RemoteBaseModel, dynamic>> createProduct({
    required dynamic name,
    required String categoryId,
    required String organizationId,
    required double price,
    Uint8List? imageBytes,
    String? imageName,
    List<Uint8List>? images,
    Map<String, dynamic>? additionalData,
    bool isNew = false,
    bool isBestSeller = false,
    bool isOnSale = false,
    bool isJoker = false,
    bool isSuperJoker = false,
    bool isAvailable = true,
    double? oldPrice,
    double? discount,
    List<Map<String, dynamic>>? priceOptions,
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating product: $name",
        context: LogContext(module: "ProductSource", method: "createProduct"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.products}?trigger=$trigger";

      Map<String, dynamic> body = {
        "name": name,
        "categoryId": categoryId,
        "organizationId": organizationId,
        "price": price,
        "oldPrice": oldPrice,
        "discount": discount,
        "isNew": isNew,
        "isBestSeller": isBestSeller,
        "isOnSale": isOnSale,
        "isJoker": isJoker,
        "isSuperJoker": isSuperJoker,
        "isAvailable": isAvailable,
        "priceOptions": priceOptions,
        if (additionalData != null) ...additionalData,
      };

      Result<RemoteBaseModel, RemoteBaseModel> result;

      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "images",
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "product_image.png",
          ),
          data: body,
          cancelToken: CancelToken(),
        );
      } else if (images != null && images.isNotEmpty) {
        body["images"] = images.asMap().entries.map((entry) {
          int index = entry.key;
          Uint8List bytes = entry.value;
          return MultipartFile.fromBytes(bytes, filename: "image_$index.png");
        }).toList();
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.POST,
          url: url,
          body: body,
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.POST,
          url: url,
          body: body,
          cancelToken: CancelToken(),
        );
      }

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Product created successfully",
          context: LogContext(module: "ProductSource", method: "createProduct"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("createProduct", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getProducts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching products - page: $page, limit: $limit",
        context: LogContext(module: "ProductSource", method: "getProducts"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.products}?page=$page&limit=$limit";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Products fetched successfully",
          context: LogContext(module: "ProductSource", method: "getProducts"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> searchProducts({
    required String name,
    required String organizationId,
  }) async {
    try {
      JDRepoConsole.info(
        "Searching products: $name in org: $organizationId",
        context: LogContext(module: "ProductSource", method: "searchProducts"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.searchProducts}?name=$name&organizationId=$organizationId";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Search completed successfully",
          context: LogContext(
            module: "ProductSource",
            method: "searchProducts",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("searchProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getDiscountedProducts() async {
    try {
      JDRepoConsole.info(
        "Searching discounted products",
        context: LogContext(
          module: "ProductSource",
          method: "getDiscountedProducts",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.discountedProducts}";
      List<String> params = [];

      if (params.isNotEmpty) url += "?${params.join("&")}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Discounted products search completed",
          context: LogContext(
            module: "ProductSource",
            method: "getDiscountedProducts",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getDiscountedProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching products for category: $categoryId - page: $page, limit: $limit",
        context: LogContext(
          module: "ProductSource",
          method: "getProductsByCategory",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.productsByCategory(categoryId)}?page=$page&limit=$limit";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Products fetched successfully",
          context: LogContext(
            module: "ProductSource",
            method: "getProductsByCategory",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getProductsByCategory", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateStock({
    required String productId,
    required int quantity,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating stock for product: $productId to quantity: $quantity",
        context: LogContext(module: "ProductSource", method: "updateStock"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.updateStock(productId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PATCH,
        url: url,
        body: {"quantity": quantity},
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Stock updated successfully",
          context: LogContext(module: "ProductSource", method: "updateStock"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("updateStock", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateProduct({
    required String productId,
    required Map<String, dynamic> data,
    Uint8List? imageBytes,
    String? imageName,
    List<Uint8List>? images,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating product: $productId",
        context: LogContext(module: "ProductSource", method: "updateProduct"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.productById(productId)}";

      Map<String, dynamic> body = Map<String, dynamic>.from(data);

      Result<RemoteBaseModel, RemoteBaseModel> result;

      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "images",
          isUpdate: true,
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "product_image.png",
          ),
          data: body,
          cancelToken: CancelToken(),
        );
      } else if (images != null && images.isNotEmpty) {
        body["images"] = images.asMap().entries.map((entry) {
          int index = entry.key;
          Uint8List bytes = entry.value;
          return MultipartFile.fromBytes(bytes, filename: "image_$index.png");
        }).toList();
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.PUT,
          url: url,
          body: body,
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.PUT,
          url: url,
          body: body,
          cancelToken: CancelToken(),
        );
      }

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Product updated successfully",
          context: LogContext(module: "ProductSource", method: "updateProduct"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("updateProduct", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteProduct(
    String productId,
  ) async {
    try {
      JDRepoConsole.info(
        "Deleting product: $productId",
        context: LogContext(module: "ProductSource", method: "deleteProduct"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.productById(productId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Product deleted successfully",
          context: LogContext(module: "ProductSource", method: "deleteProduct"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("deleteProduct", e);
    }
  }

  // --- Bulk Operations ---

  Future<Result<RemoteBaseModel, dynamic>> bulkCreateProducts({
    required BulkCreateProductsRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Bulk creating ${request.products.length} products for org: ${request.organizationId}",
        context: LogContext(
          module: "ProductSource",
          method: "bulkCreateProducts",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.bulkProducts}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("bulkCreateProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> bulkUpdateProducts({
    required BulkUpdateProductsRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Bulk updating ${request.productIds.length} products for org: ${request.organizationId}",
        context: LogContext(
          module: "ProductSource",
          method: "bulkUpdateProducts",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.bulkUpdateProducts}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PATCH,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("bulkUpdateProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> bulkDeleteProducts({
    required BulkDeleteProductsRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Bulk deleting ${request.productIds.length} products for org: ${request.organizationId}",
        context: LogContext(
          module: "ProductSource",
          method: "bulkDeleteProducts",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.bulkDeleteProducts}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("bulkDeleteProducts", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> bulkVariants({
    required BulkVariantsRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating bulk variants for template in org: ${request.organizationId}",
        context: LogContext(module: "ProductSource", method: "bulkVariants"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.bulkVariants}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("bulkVariants", e);
    }
  }

  // --- Shared Pricing Tools ---

  Future<Result<RemoteBaseModel, dynamic>> sharedPricingPreview({
    required SharedPricingRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Previewing shared pricing for ${request.productIds.length} products",
        context: LogContext(
          module: "ProductSource",
          method: "sharedPricingPreview",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.sharedPricingPreview}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("sharedPricingPreview", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> sharedPricingApply({
    required SharedPricingRequest request,
  }) async {
    try {
      JDRepoConsole.info(
        "Applying shared pricing to ${request.productIds.length} products",
        context: LogContext(
          module: "ProductSource",
          method: "sharedPricingApply",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.sharedPricingApply}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: request.toJson(),
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("sharedPricingApply", e);
    }
  }

  Result<RemoteBaseModel, dynamic> _wrap(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }

    String? message = result.error?.message ?? result.data?.message;

    if (result.data?.data is Map) {
      final dataMap = result.data?.data as Map;
      final msg =
          dataMap['message'] ??
          dataMap['error'] ??
          dataMap['errors'] ??
          dataMap['detail'];
      if (msg != null) {
        if (msg is List) {
          message = msg.join(', ');
        } else {
          message = msg.toString();
        }
      }
    }

    return Result.error(
      RemoteBaseModel(
        message: message ?? 'خطأ غير معروف',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "ProductSource", method: method),
    );

    String message = "حدث خطأ غير متوقع";
    dynamic errorData;

    if (e is DioError) {
      errorData = e.response?.data;
      if (errorData is Map) {
        final msg =
            errorData['message'] ??
            errorData['error'] ??
            errorData['errors'] ??
            errorData['detail'];
        if (msg != null) {
          if (msg is List) {
            message = msg.join(', ');
          } else {
            message = msg.toString();
          }
        } else {
          message = e.message ?? "خطأ في الاتصال بالسيرفر";
        }
      } else {
        message = e.message ?? "خطأ في الاتصال بالسيرفر";
      }
    } else {
      message = e.toString();
    }

    return Result.error(
      RemoteBaseModel(
        message: message,
        status: StatusModel.error,
        data: errorData,
      ),
    );
  }
}
