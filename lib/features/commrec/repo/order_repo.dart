import 'package:matger_pro_core_logic/features/commrec/data/order_model.dart';
import 'package:matger_pro_core_logic/features/commrec/source/order_source.dart';
import 'package:matger_pro_core_logic/features/workflow/repo/workflow_repo.dart';
import 'package:matger_pro_core_logic/features/workflow/request_body/workflow_request_bodies.dart';
import 'package:matger_pro_core_logic/features/workflow/data/workflow_model.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderRepo {
  late final OrderSource _orderSource;
  late final WorkflowRepo _workflowRepo;

  OrderRepo({OrderSource? orderSource, WorkflowRepo? workflowRepo}) {
    _orderSource = orderSource ?? OrderSource();
    _workflowRepo = workflowRepo ?? WorkflowRepo();
  }

  Future<RemoteBaseModel<OrderData>> createOrder({
    required String organizationId,
    OrderContactDetails? senderDetails,
    OrderContactDetails? recipientDetails,
    required List<OrderItemData> items,
    required double totalOrderPrice,
    String orderMode = 'C2B',
    String? workflowSlug,
    int calculationMode = 2,
    Map<String, dynamic>? additionalData,
  }) async {
    JDRepoConsole.info(
      "Creating order in repo for organization: $organizationId",
      context: LogContext(module: "OrderRepo", method: "createOrder"),
    );
    final result = await _orderSource.createOrder(
      organizationId: organizationId,
      senderDetails: senderDetails?.toJson(),
      recipientDetails: recipientDetails?.toJson(),
      totalOrderPrice: totalOrderPrice,
      orderMode: orderMode,
      items: items.map((e) => e.toJson()).toList(),
      workflowSlug: workflowSlug,
      calculationMode: calculationMode,
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

  Future<RemoteBaseModel<OrderData>> updateOrderItems({
    required String orderId,
    required List<OrderItemData> items,
    required double totalOrderPrice,
    int calculationMode = 2,
  }) async {
    JDRepoConsole.info(
      "Updating order items in repo for order: $orderId",
      context: LogContext(module: "OrderRepo", method: "updateOrderItems"),
    );
    final result = await _orderSource.updateOrderItems(
      orderId: orderId,
      items: items.map((e) => e.toJson()).toList(),
      totalOrderPrice: totalOrderPrice,
      calculationMode: calculationMode,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in updateOrderItems: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "updateOrderItems"),
      );
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
        message: result.error?.message ?? "خطأ في تحديث المنتجات",
      );
    }
  }

  Future<RemoteBaseModel<List<OrderData>>> getOrganizationOrders({
    int page = 1,
    int limit = 10,
    int? currentStepIndex,
    String? workflowSlug,
  }) async {
    JDRepoConsole.info(
      "Getting organization orders in repo",
      context: LogContext(module: "OrderRepo", method: "getOrganizationOrders"),
    );
    final result = await _orderSource.getOrganizationOrders(
      page: page,
      limit: limit,
      currentStepIndex: currentStepIndex,
      workflowSlug: workflowSlug,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationOrders: ${result.error?.message}",
        context: LogContext(module: "OrderRepo", method: "getOrganizationOrders"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final List ordersList;
      final data = result.data;
      if (data is List) {
        ordersList = data;
      } else if (data is Map && data['data'] is List) {
        ordersList = data['data'];
      } else {
        ordersList = [];
      }

      final orders = ordersList
          .map((e) => OrderData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${orders.length} organization orders successfully",
        context: LogContext(module: "OrderRepo", method: "getOrganizationOrders"),
      );
      return RemoteBaseModel(data: orders, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationOrders: $e",
        context: LogContext(module: "OrderRepo", method: "getOrganizationOrders"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message ?? "خطأ في جلب الطلبات",
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
    return _workflowRepo.getStatus<OrderData>(
      entityType: 'orders',
      entryId: orderId,
      parser: (data) => OrderData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<OrderData>> performWorkflowAction(
    String orderId,
    Map<String, dynamic> actionData,
  ) async {
    JDRepoConsole.info(
      "Performing workflow action in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "performWorkflowAction"),
    );
    // Use WorkflowRepo instead of direct HTTP call
    return _workflowRepo.performAction<OrderData>(
      entityType: 'orders',
      entryId: orderId,
      request: WorkflowExecuteActionRequest(
        actionName: actionData['actionName'] ?? '',
        expectedStepNumber: actionData['expectedStepNumber'],
        targetUserId: actionData['targetUserId'],
      ),
      parser: (data) => OrderData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<OrderData>> claimOrder(
    String orderId, {
    int? expectedStepNumber,
  }) async {
    JDRepoConsole.info(
      "Claiming order in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "claimOrder"),
    );
    return _workflowRepo.claimTask<OrderData>(
      entityType: 'orders',
      entryId: orderId,
      request: WorkflowClaimTaskRequest(expectedStepNumber: expectedStepNumber),
      parser: (data) => OrderData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<OrderData>> executeOrderAction(
    String orderId, {
    required String actionName,
    int? expectedStepNumber,
  }) async {
    JDRepoConsole.info(
      "Executing action $actionName for order in repo: $orderId",
      context: LogContext(module: "OrderRepo", method: "executeOrderAction"),
    );
    return _workflowRepo.performAction<OrderData>(
      entityType: 'orders',
      entryId: orderId,
      request: WorkflowExecuteActionRequest(
        actionName: actionName,
        expectedStepNumber: expectedStepNumber,
      ),
      parser: (data) => OrderData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<OrderData>> assignOrder(
    String orderId, {
    required String targetUserId,
    int? expectedStepNumber,
  }) async {
    JDRepoConsole.info(
      "Assigning order $orderId to user $targetUserId in repo",
      context: LogContext(module: "OrderRepo", method: "assignOrder"),
    );
    return _workflowRepo.assignTask<OrderData>(
      entityType: 'orders',
      entryId: orderId,
      request: WorkflowAssignTaskRequest(
        targetUserId: targetUserId,
        expectedStepNumber: expectedStepNumber,
      ),
      parser: (data) => OrderData.fromJson(data),
    );
  }

  Future<RemoteBaseModel<WorkflowData>> getWorkflowRoadmap(String slug) async {
    JDRepoConsole.info(
      "Getting workflow roadmap in repo for slug: $slug",
      context: LogContext(module: "OrderRepo", method: "getWorkflowRoadmap"),
    );
    return _workflowRepo.getTemplate(slug: slug);
  }
}
