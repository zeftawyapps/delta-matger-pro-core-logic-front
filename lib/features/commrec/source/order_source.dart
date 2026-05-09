import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_pro_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderSource {
  OrderSource();

  Future<Result<RemoteBaseModel, dynamic>> createOrder({
    required String organizationId,
    Map<String, dynamic>? senderDetails,
    Map<String, dynamic>? recipientDetails,
    required List<Map<String, dynamic>> items,
    required double totalOrderPrice,
    String orderMode = 'C2B',
    String? workflowSlug,
    int calculationMode = 2,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      JDRepoConsole.info(
        "Creating order for organization: $organizationId",
        context: LogContext(module: "OrderSource", method: "createOrder"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.ordersByOrg(organizationId)}";
      final queryParameters = {
        if (workflowSlug != null) "workflowSlug": workflowSlug,
        "allowDefaultWorkflow": true,
        "calculationMode": calculationMode,
        "orderMode": orderMode,
      };
      final body = {
        if (senderDetails != null) "senderDetails": senderDetails,
        if (recipientDetails != null) "recipientDetails": recipientDetails,
        "totalOrderPrice": totalOrderPrice,
        "items": items,
        if (additionalData != null) ...additionalData,
      };

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        queryParameters: queryParameters,
        body: body,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("createOrder", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalOrderPrice,
    int calculationMode = 2,
  }) async {
    try {
      JDRepoConsole.info(
        "Updating items for order: $orderId",
        context: LogContext(module: "OrderSource", method: "updateOrderItems"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderById(orderId)}";
      final queryParameters = {
        "calculationMode": calculationMode,
      };
      final body = {
        "items": items,
        "totalOrderPrice": totalOrderPrice,
      };

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        queryParameters: queryParameters,
        body: body,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrderItems", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrganizationOrders({
    int page = 1,
    int limit = 10,
    int? currentStepIndex,
    String? workflowSlug,
  }) async {
    try {
      JDRepoConsole.info(
        "Fetching organization orders - Page: $page, Limit: $limit, WorkflowSlug: $workflowSlug, StepIndex: $currentStepIndex",
        context: LogContext(module: "OrderSource", method: "getOrganizationOrders"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.ordersOrganization}";
      final queryParameters = {
        "page": page,
        "limit": limit,
        if (currentStepIndex != null) "currentStepIndex": currentStepIndex,
        if (workflowSlug != null) "workflowSlug": workflowSlug,
      };

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        queryParameters: queryParameters,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrganizationOrders", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getShopOrders(String shopId) async {
    try {
      JDRepoConsole.info(
        "Fetching orders for shop: $shopId",
        context: LogContext(module: "OrderSource", method: "getShopOrders"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.shopOrders(shopId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getShopOrders", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrderById(String orderId) async {
    try {
      JDRepoConsole.info(
        "Fetching order by ID: $orderId",
        context: LogContext(module: "OrderSource", method: "getOrderById"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderById(orderId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("getOrderById", e);
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      JDRepoConsole.info(
        "Updating order status: $orderId to $status",
        context: LogContext(module: "OrderSource", method: "updateOrderStatus"),
      );
      String url = "${ApiUrls.BASE_URL}${EndPoints.updateOrderStatus(orderId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {"status": status},
        cancelToken: CancelToken(),
      );
      return _wrap(result);
    } catch (e) {
      return _catchError("updateOrderStatus", e);
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
      context: LogContext(module: "OrderSource", method: method),
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
