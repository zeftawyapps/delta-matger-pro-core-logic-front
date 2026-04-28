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
import 'dart:convert';

class OfferSource {
  OfferSource();

  Future<Result<RemoteBaseModel, dynamic>> createOffer({
    required Map<String, String> name,
    required String organizationId,
    Map<String, String>? description,
    required String targetType,
    required String targetId,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool isActive = true,
    int? sortOrder,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating offer for organization: $organizationId",
        context: LogContext(module: "OfferSource", method: "createOffer"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.offers}";

      final Map<String, dynamic> data = {
        "name": jsonEncode(name),
        "organizationId": organizationId,
        "targetType": targetType,
        "targetId": targetId,
        "isActive": isActive.toString(),
      };

      if (description != null) data["description"] = jsonEncode(description);
      if (discountPercentage != null)
        data["discountPercentage"] = discountPercentage.toString();
      if (startDate != null) data["startDate"] = startDate.toIso8601String();
      if (endDate != null) data["endDate"] = endDate.toIso8601String();
      if (sortOrder != null) data["sortOrder"] = sortOrder.toString();

      Result<RemoteBaseModel<dynamic>, RemoteBaseModel<dynamic>> result;
      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "image",
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "offer_image.png",
          ),
          data: data,
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.POST,
          url: url,
          body: data,
          cancelToken: CancelToken(),
        );
      }

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Offer created successfully",
          context: LogContext(module: "OfferSource", method: "createOffer"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("createOffer", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOffersByOrganization(
    String organizationId, {
    String? lang,
    bool? activeOnly,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching offers for organization: $organizationId",
        context: LogContext(
          module: "OfferSource",
          method: "getOffersByOrganization",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orgOffers(organizationId)}";

      final Map<String, dynamic> queryParams = {};
      if (lang != null) queryParams["lang"] = lang;
      if (activeOnly != null) queryParams["activeOnly"] = activeOnly.toString();

      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        queryParameters: queryParams,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Offers fetched successfully",
          context: LogContext(
            module: "OfferSource",
            method: "getOffersByOrganization",
          ),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getOffersByOrganization", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOfferById(
    String offerId, {
    String? lang,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching offer by ID: $offerId",
        context: LogContext(module: "OfferSource", method: "getOfferById"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.offerById(offerId)}";

      final Map<String, dynamic> queryParams = {};
      if (lang != null) queryParams["lang"] = lang;

      final result = await HttpClient(userToken: false).sendRequest(
        method: HttpMethod.GET,
        url: url,
        queryParameters: queryParams,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Offer fetched successfully",
          context: LogContext(module: "OfferSource", method: "getOfferById"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("getOfferById", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOffer({
    required String offerId,
    Map<String, String>? name,
    Map<String, String>? description,
    String? targetType,
    String? targetId,
    double? discountPercentage,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? sortOrder,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating offer: $offerId",
        context: LogContext(module: "OfferSource", method: "updateOffer"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.offerById(offerId)}";

      final Map<String, dynamic> data = {};
      if (name != null) data["name"] = jsonEncode(name);
      if (description != null) data["description"] = jsonEncode(description);
      if (targetType != null) data["targetType"] = targetType;
      if (targetId != null) data["targetId"] = targetId;
      if (isActive != null) data["isActive"] = isActive.toString();
      if (discountPercentage != null)
        data["discountPercentage"] = discountPercentage.toString();
      if (startDate != null) data["startDate"] = startDate.toIso8601String();
      if (endDate != null) data["endDate"] = endDate.toIso8601String();
      if (sortOrder != null) data["sortOrder"] = sortOrder.toString();

      Result<RemoteBaseModel<dynamic>, RemoteBaseModel<dynamic>> result;
      if (imageBytes != null) {
        result = await HttpClient(userToken: true).uploadMapResult(
          url: url,
          fileKey: "image",
          isUpdate: true,
          file: MultipartFile.fromBytes(
            imageBytes,
            filename: imageName ?? "offer_image.png",
          ),
          data: data,
          cancelToken: CancelToken(),
        );
      } else {
        result = await HttpClient(userToken: true).sendRequest(
          method: HttpMethod.PUT,
          url: url,
          body: data,
          cancelToken: CancelToken(),
        );
      }

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Offer updated successfully",
          context: LogContext(module: "OfferSource", method: "updateOffer"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("updateOffer", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> deleteOffer(String offerId) async {
    try {
      JDRepoConsole.info(
        "Deleting offer: $offerId",
        context: LogContext(module: "OfferSource", method: "deleteOffer"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.offerById(offerId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );

      if (result.data?.status == StatusModel.success) {
        JDRepoConsole.success(
          "Offer deleted successfully",
          context: LogContext(module: "OfferSource", method: "deleteOffer"),
        );
        return Result.data(result.data?.data);
      }
      return _wrap(result);
    } catch (e) {
      return _catchError("deleteOffer", e);
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
        message: message ?? 'خطأ غير معروف في الباك اند',
        status: result.data?.status ?? StatusModel.error,
        data: result.data?.data ?? result.error?.data,
      ),
    );
  }

  Result<RemoteBaseModel, dynamic> _catchError(String method, Object e) {
    JDRepoConsole.error(
      "Error in $method: $e",
      context: LogContext(module: "OfferSource", method: method),
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
