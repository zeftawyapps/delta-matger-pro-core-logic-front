import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
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
      JDRepoConsole.info("Creating category: $name",
          context: LogContext(module: "CategorySource", method: "createCategory"));
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
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Category created successfully",
            context: LogContext(module: "CategorySource", method: "createCategory"));
      } else {
        JDRepoConsole.error("Category creation failed",
            context: LogContext(
                module: "CategorySource",
                method: "createCategory",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error creating category: $e",
          context: LogContext(module: "CategorySource", method: "createCategory"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getActiveCategories() async {
    try {
      JDRepoConsole.info("Fetching active categories",
          context: LogContext(module: "CategorySource", method: "getActiveCategories"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.activeCategories}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Active categories fetched successfully",
            context: LogContext(module: "CategorySource", method: "getActiveCategories"));
      } else {
        JDRepoConsole.error("Failed to fetch active categories",
            context: LogContext(
                module: "CategorySource",
                method: "getActiveCategories",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error fetching active categories: $e",
          context: LogContext(module: "CategorySource", method: "getActiveCategories"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getCategoriesByOrganization(
    String organizationId,
  ) async {
    try {
      JDRepoConsole.info("Fetching categories for organization: $organizationId",
          context:
              LogContext(module: "CategorySource", method: "getCategoriesByOrganization"));
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.orgCategories(organizationId)}";
      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Categories fetched successfully",
            context:
                LogContext(module: "CategorySource", method: "getCategoriesByOrganization"));
      } else {
        JDRepoConsole.error("Failed to fetch categories",
            context: LogContext(
                module: "CategorySource",
                method: "getCategoriesByOrganization",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error fetching categories: $e",
          context:
              LogContext(module: "CategorySource", method: "getCategoriesByOrganization"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
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
      JDRepoConsole.info("Updating category: $categoryId",
          context: LogContext(module: "CategorySource", method: "updateCategory"));
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
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Category updated successfully",
            context: LogContext(module: "CategorySource", method: "updateCategory"));
      } else {
        JDRepoConsole.error("Category update failed",
            context: LogContext(
                module: "CategorySource",
                method: "updateCategory",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error updating category: $e",
          context: LogContext(module: "CategorySource", method: "updateCategory"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteCategory(
    String categoryId, {
    bool trigger = true,
  }) async {
    try {
      JDRepoConsole.info("Deleting category: $categoryId",
          context: LogContext(module: "CategorySource", method: "deleteCategory"));
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.categories}/$categoryId?trigger=$trigger";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Category deleted successfully",
            context: LogContext(module: "CategorySource", method: "deleteCategory"));
      } else {
        JDRepoConsole.error("Category deletion failed",
            context: LogContext(
                module: "CategorySource",
                method: "deleteCategory",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error deleting category: $e",
          context: LogContext(module: "CategorySource", method: "deleteCategory"));
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
