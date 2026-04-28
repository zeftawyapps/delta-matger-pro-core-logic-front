import 'package:matger_pro_core_logic/features/commrec/data/order_model.dart';
import 'package:matger_pro_core_logic/features/commrec/source/order_source.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderRepo {
  late final OrderSource _orderSource;

  OrderRepo({OrderSource? orderSource}) {
    _orderSource = orderSource ?? OrderSource();
  }

  Future<RemoteBaseModel<OrderData>> createOrder({
    required String organizationId,
    required OrderContactDetails senderDetails,
    required OrderContactDetails recipientDetails,
    required List<OrderItemData> items,
    required double totalOrderPrice,
    String orderMode = 'C2B',
    Map<String, dynamic>? additionalData,
  }) async {
    JDRepoConsole.info(
      "Creating order in repo for organization: $organizationId",
      context: LogContext(module: "OrderRepo", method: "createOrder"),
    );
    final result = await _orderSource.createOrder(
      organizationId: organizationId,
      senderDetails: senderDetails.toJson(),
      recipientDetails: recipientDetails.toJson(),
      totalOrderPrice: totalOrderPrice,
      orderMode: orderMode,
      items: items.map((e) => e.toJson()).toList(),
      additionalData: additionalData,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createOrder: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "createOrder"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final order = OrderData.fromJson(result.data as Map<String, dynamic>);
      JDRepoConsole.success(
        "Order parsed successfully in repo",
        context: LogContext(module: "OrderRepo", method: "createOrder"),
      );
      return RemoteBaseModel(data: order, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createOrder: $e",
        context: LogContext(
          module: "OrderRepo",
          method: "createOrder",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في إنشاء الطلب",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<List<OrderData>>> getShopOrders(String shopId) async {
    JDRepoConsole.info(
      "Getting shop orders in repo: $shopId",
      context: LogContext(module: "OrderRepo", method: "getShopOrders"),
    );
    final result = await _orderSource.getShopOrders(shopId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getShopOrders: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "getShopOrders"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final data = result.data;
      final List ordersList;

      if (data is List) {
        ordersList = data;
      } else if (data is Map && data['data'] is List) {
        ordersList = data['data'];
      } else if (data is Map && data['orders'] is List) {
        ordersList = data['orders'];
      } else {
        ordersList = [];
      }

      final orders = ordersList
          .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${orders.length} orders successfully in repo",
        context: LogContext(module: "OrderRepo", method: "getShopOrders"),
      );
      return RemoteBaseModel(data: orders, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getShopOrders: $e",
        context: LogContext(
          module: "OrderRepo",
          method: "getShopOrders",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب الطلبات",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrderData>> getOrderById(String orderId) async {
    JDRepoConsole.info(
      "Getting order by ID in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "getOrderById"),
    );
    final result = await _orderSource.getOrderById(orderId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrderById: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "getOrderById"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final order = OrderData.fromJson(result.data as Map<String, dynamic>);
      JDRepoConsole.success(
        "Order fetched and parsed successfully in repo",
        context: LogContext(module: "OrderRepo", method: "getOrderById"),
      );
      return RemoteBaseModel(data: order, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrderById: $e",
        context: LogContext(
          module: "OrderRepo",
          method: "getOrderById",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب بيانات الطلب",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<bool>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    JDRepoConsole.info(
      "Updating order status in repo: $orderId to $status",
      context: LogContext(module: "OrderRepo", method: "updateOrderStatus"),
    );
    final result = await _orderSource.updateOrderStatus(orderId, status);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrderStatus: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "updateOrderStatus"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      "Order status updated successfully in repo",
      context: LogContext(module: "OrderRepo", method: "updateOrderStatus"),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }

  Future<RemoteBaseModel<OrderData>> trackOrderStatus(String orderId) async {
    JDRepoConsole.info(
      "Tracking order status in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "trackOrderStatus"),
    );
    final result = await _orderSource.trackOrderStatus(orderId);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final order = OrderData.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: order, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تتبع الطلب",
        data: null,
      );
    }
  }

  Future<RemoteBaseModel<OrderData>> performWorkflowAction(
    String orderId,
    Map<String, dynamic> actionData,
  ) async {
    JDRepoConsole.info(
      "Performing workflow action in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "performWorkflowAction"),
    );
    final result = await _orderSource.performWorkflowAction(orderId, actionData);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final order = OrderData.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: order, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في تنفيذ الإجراء",
        data: null,
      );
    }
  }
}
