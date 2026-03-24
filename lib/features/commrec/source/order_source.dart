import 'package:JoDija_reposatory/utilis/http_remotes/http_client.dart';
import 'package:JoDija_reposatory/utilis/http_remotes/http_methos_enum.dart';
import 'package:JoDija_reposatory/constes/api_urls.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/result/result.dart';
import 'package:dio/dio.dart';
import 'package:matger_core_logic/consts/end_points.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderSource {
  OrderSource();

  Future<Result<RemoteBaseModel, dynamic>> createOrder({
    required String organizationId,
    String? customerId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      JDRepoConsole.info("Creating order for organization: $organizationId",
          context: LogContext(module: "OrderSource", method: "createOrder"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.orders}";
      final body = {
        "organizationId": organizationId,
        if (customerId != null) "customerId": customerId,
        "totalAmount": totalAmount,
        "items": items,
        if (additionalData != null) ...additionalData,
      };

      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.POST,
        url: url,
        body: body,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Order created successfully",
            context: LogContext(module: "OrderSource", method: "createOrder"));
      } else {
        JDRepoConsole.error("Order creation failed",
            context: LogContext(
                module: "OrderSource",
                method: "createOrder",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error creating order: $e",
          context: LogContext(module: "OrderSource", method: "createOrder"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getShopOrders(String shopId) async {
    try {
      JDRepoConsole.info("Fetching orders for shop: $shopId",
          context: LogContext(module: "OrderSource", method: "getShopOrders"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.shopOrders(shopId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Shop orders fetched successfully",
            context: LogContext(module: "OrderSource", method: "getShopOrders"));
      } else {
        JDRepoConsole.error("Failed to fetch shop orders",
            context: LogContext(
                module: "OrderSource",
                method: "getShopOrders",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error fetching shop orders: $e",
          context: LogContext(module: "OrderSource", method: "getShopOrders"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> getOrderById(String orderId) async {
    try {
      JDRepoConsole.info("Fetching order by ID: $orderId",
          context: LogContext(module: "OrderSource", method: "getOrderById"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.orderById(orderId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.GET,
        url: url,
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Order fetched successfully",
            context: LogContext(module: "OrderSource", method: "getOrderById"));
      } else {
        JDRepoConsole.error("Failed to fetch order",
            context: LogContext(
                module: "OrderSource",
                method: "getOrderById",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error fetching order: $e",
          context: LogContext(module: "OrderSource", method: "getOrderById"));
      return Result.error(
        RemoteBaseModel(message: e.toString(), status: StatusModel.error),
      );
    }
  }

  Future<Result<RemoteBaseModel, dynamic>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      JDRepoConsole.info("Updating order status: $orderId to $status",
          context: LogContext(module: "OrderSource", method: "updateOrderStatus"));
      String url = "${ApiUrls.BASE_URL}${EndPoints.updateOrderStatus(orderId)}";
      final result = await HttpClient(userToken: true).sendRequest(
        method: HttpMethod.PUT,
        url: url,
        body: {"status": status},
        cancelToken: CancelToken(),
      );
      final handledResult = _handleResult(result);
      if (handledResult.data != null) {
        JDRepoConsole.success("Order status updated successfully",
            context: LogContext(module: "OrderSource", method: "updateOrderStatus"));
      } else {
        JDRepoConsole.error("Failed to update order status",
            context: LogContext(
                module: "OrderSource",
                method: "updateOrderStatus",
                metadata: handledResult.error));
      }
      return handledResult;
    } catch (e) {
      JDRepoConsole.error("Error updating order status: $e",
          context: LogContext(module: "OrderSource", method: "updateOrderStatus"));
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
