import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';
import 'dart:typed_data';

class CategorySource {
  CategorySource();

  Future<Result<RemoteBaseModel, dynamic>> createCategory({
    required String name,
    required String shopId,
    String? description,
    Uint8List? imageBytes,
    String? imageName,
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating category: $name",
        context: LogContext(module: "CategorySource", method: "createCategory"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.categories}?trigger=$trigger";

      Result<RemoteBaseModel<dynamic>, RemoteBaseModel<dynamic>> result;
      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "image",
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "image.png",
          ),
          data: {
            "name": name,
            "organizationId": shopId,
            if (description != null) "description": description,
          },
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.POST,
          url: url,
          body: {
            "name": name,
            "organizationId": shopId,
            if (description != null) "description": description,
          },
          cancelToken: CancelToken(),
        );
      }
      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Category created successfully",
          context: LogContext(
            module: "CategorySource",
            method: "createCategory",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("createCategory", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getActiveCategories() async {
    try {
      JDRepoConsole.info(
        "Fetching active categories",
        context: LogContext(
          module: "CategorySource",
          method: "getActiveCategories",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.activeCategories}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Active categories fetched successfully",
          context: LogContext(
            module: "CategorySource",
            method: "getActiveCategories",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getActiveCategories", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getCategoriesByOrganization(
    String organizationId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching categories for organization: $organizationId",
        context: LogContext(
          module: "CategorySource",
          method: "getCategoriesByOrganization",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.orgCategories(organizationId)}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Categories fetched successfully",
          context: LogContext(
            module: "CategorySource",
            method: "getCategoriesByOrganization",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getCategoriesByOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateCategory({
    required String categoryId,
    String? name,
    bool? isActive,
    Uint8List? imageBytes,
    String? imageName,
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating category: $categoryId",
        context: LogContext(module: "CategorySource", method: "updateCategory"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.categories}/$categoryId?trigger=$trigger";

      Result<RemoteBaseModel<dynamic>, RemoteBaseModel<dynamic>> result;
      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "image",
          isUpdate: true,
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "image.png",
          ),
          data: {
            if (name != null) "name": name,
            if (isActive != null) "isActive": isActive.toString(),
          },
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.PUT,
          url: url,
          body: {
            if (name != null) "name": name,
            if (isActive != null) "isActive": isActive.toString(),
          },
          cancelToken: CancelToken(),
        );
      }

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Category updated successfully",
          context: LogContext(
            module: "CategorySource",
            method: "updateCategory",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("updateCategory", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteCategory(
    String categoryId, {
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info(
        "Deleting category: $categoryId",
        context: LogContext(module: "CategorySource", method: "deleteCategory"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.categories}/$categoryId?trigger=$trigger";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Category deleted successfully",
          context: LogContext(
            module: "CategorySource",
            method: "deleteCategory",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("deleteCategory", e);
    }
  }

  Result<RemoteBaseModel, dynamic> _wrap(
    Result<RemoteBaseModel, RemoteBaseModel> result,
  ) {
    if (result.data?.status == StatusModel.success) {
      return Result.data(result.data?.data);
    }

    String? message = result.error?.message ?? result.data?.message;

    // Try to extract more details if message is still null or generic
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
        message: message ?? 'خطأ غير معروف في الباك اند',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "CategorySource", method: method),
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
