import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderPathSource {
  OrderPathSource();

  /// إنشاء خط سير جديد
  Future<Result<RemoteBaseModel, dynamic>> createOrderPath({
    required String organizationId,
    required Map<String, dynamic> body,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating order path for organization: $organizationId",
        context: LogContext(module: "OrderPathSource", method: "createOrderPath"),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.orderPathsByOrg(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: body,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("createOrderPath", e);
    }
  }

  /// جلب كل خطوط السير الخاصة بمؤسسة
  Future<Result<RemoteBaseModel, dynamic>> getOrganizationOrderPaths(
    String organizationId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching order paths for organization: $organizationId",
        context: LogContext(
          module: "OrderPathSource",
          method: "getOrganizationOrderPaths",
        ),
      );
      String url =
          "${ApiUrls.BASE_URL}${EndPoints.orderPathsOfOrg(organizationId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationOrderPaths", e);
    }
  }

  /// جلب تفاصيل خط سير بالـ ID
  Future<Result<RemoteBaseModel, dynamic>> getOrderPathById(
    String pathId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching order path: $pathId",
        context: LogContext(
          module: "OrderPathSource",
          method: "getOrderPathById",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderPathById(pathId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrderPathById", e);
    }
  }

  /// جلب طلبات خط سير معين
  Future<Result<RemoteBaseModel, dynamic>> getOrderPathOrders(
    String pathId,
  ) async {
    try {
      JDRepoConsole.info(
        "Fetching orders for path: $pathId",
        context: LogContext(
          module: "OrderPathSource",
          method: "getOrderPathOrders",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderPathOrders(pathId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrderPathOrders", e);
    }
  }

  /// تعديل خط سير
  Future<Result<RemoteBaseModel, dynamic>> updateOrderPath({
    required String pathId,
    required Map<String, dynamic> body,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating order path: $pathId",
        context: LogContext(
          module: "OrderPathSource",
          method: "updateOrderPath",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderPathById(pathId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: body,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrderPath", e);
    }
  }

  /// حذف خط سير
  Future<Result<RemoteBaseModel, dynamic>> deleteOrderPath(
    String pathId,
  ) async {
    try {
      JDRepoConsole.info(
        "Deleting order path: $pathId",
        context: LogContext(
          module: "OrderPathSource",
          method: "deleteOrderPath",
        ),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderPathById(pathId)}";

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.DELETE,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("deleteOrderPath", e);
    }
  }

  // ==========================================
  // Helpers
  // ==========================================

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
      context: LogContext(module: "OrderPathSource", method: method),
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
