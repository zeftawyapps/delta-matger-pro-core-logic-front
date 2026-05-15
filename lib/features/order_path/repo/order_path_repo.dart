import 'package:matger_pro_core_logic/features/order_path/data/order_path_model.dart';
import 'package:matger_pro_core_logic/features/order_path/source/order_path_source.dart';
import 'package:matger_pro_core_logic/features/commrec/data/order_model.dart';
import 'package:JoDija_reposatory/utilis/models/remote_base_model.dart';
import 'package:JoDija_reposatory/utilis/models/staus_model.dart';
import 'package:JoDija_reposatory/utilis/functions/jd_repo_console.dart';

class OrderPathRepo {
  late final OrderPathSource _source;

  OrderPathRepo({OrderPathSource? source}) {
    _source = source ?? OrderPathSource();
  }

  /// إنشاء خط سير جديد
  Future<RemoteBaseModel<OrderPathData>> createOrderPath({
    required String organizationId,
    required String name,
    required List<String> regions,
    String? workflowSlug,
    int? triggerStepNumber,
    bool autoAssign = true,
    Map<String, dynamic>? schedule,
  }) async {
    JDRepoConsole.info(
      "Creating order path in repo for organization: $organizationId",
      context: LogContext(module: "OrderPathRepo", method: "createOrderPath"),
    );

    final body = {
      'name': name,
      'regions': regions,
      if (workflowSlug != null) 'workflowSlug': workflowSlug,
      if (triggerStepNumber != null) 'triggerStepNumber': triggerStepNumber,
      'autoAssign': autoAssign,
      if (schedule != null) 'schedule': schedule,
    };

    final result = await _source.createOrderPath(
      organizationId: organizationId,
      body: body,
    );

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in createOrderPath: ${result.error?.message}",
        context: LogContext(module: "OrderPathRepo", method: "createOrderPath"),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final path = OrderPathData.fromJson(result.data as Map<String, dynamic>);
      JDRepoConsole.success(
        "Order path created successfully in repo",
        context: LogContext(module: "OrderPathRepo", method: "createOrderPath"),
      );
      return RemoteBaseModel(data: path, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in createOrderPath: $e",
        context: LogContext(
          module: "OrderPathRepo",
          method: "createOrderPath",
          metadata: result.data,
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "خطأ في إنشاء خط السير",
      );
    }
  }

  /// جلب كل خطوط السير الخاصة بمؤسسة
  Future<RemoteBaseModel<List<OrderPathData>>> getOrganizationOrderPaths(
    String organizationId,
  ) async {
    JDRepoConsole.info(
      "Getting organization order paths in repo: $organizationId",
      context: LogContext(
        module: "OrderPathRepo",
        method: "getOrganizationOrderPaths",
      ),
    );

    final result = await _source.getOrganizationOrderPaths(organizationId);

    if (result.error != null) {
      JDRepoConsole.error(
        "Source error in getOrganizationOrderPaths: ${result.error?.message}",
        context: LogContext(
          module: "OrderPathRepo",
          method: "getOrganizationOrderPaths",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final List pathsList;
      final data = result.data;
      if (data is List) {
        pathsList = data;
      } else if (data is Map && data['data'] is List) {
        pathsList = data['data'];
      } else {
        pathsList = [];
      }

      final paths = pathsList
          .map((e) => OrderPathData.fromJson(e as Map<String, dynamic>))
          .toList();
      JDRepoConsole.success(
        "Fetched ${paths.length} order paths successfully",
        context: LogContext(
          module: "OrderPathRepo",
          method: "getOrganizationOrderPaths",
        ),
      );
      return RemoteBaseModel(data: paths, status: StatusModel.success);
    } catch (e) {
      JDRepoConsole.error(
        "Parsing error in getOrganizationOrderPaths: $e",
        context: LogContext(
          module: "OrderPathRepo",
          method: "getOrganizationOrderPaths",
        ),
      );
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "خطأ في جلب خطوط السير",
      );
    }
  }

  /// جلب تفاصيل خط سير
  Future<RemoteBaseModel<OrderPathData>> getOrderPathById(
    String pathId,
  ) async {
    JDRepoConsole.info(
      "Getting order path by ID in repo: $pathId",
      context: LogContext(module: "OrderPathRepo", method: "getOrderPathById"),
    );

    final result = await _source.getOrderPathById(pathId);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final path = OrderPathData.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: path, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "خطأ في جلب بيانات خط السير",
      );
    }
  }

  /// جلب طلبات خط سير معين
  Future<RemoteBaseModel<List<OrderData>>> getOrderPathOrders(
    String pathId,
  ) async {
    JDRepoConsole.info(
      "Getting orders for path in repo: $pathId",
      context: LogContext(module: "OrderPathRepo", method: "getOrderPathOrders"),
    );

    final result = await _source.getOrderPathOrders(pathId);

    if (result.error != null) {
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
        "Fetched ${orders.length} orders for path successfully",
        context: LogContext(
          module: "OrderPathRepo",
          method: "getOrderPathOrders",
        ),
      );
      return RemoteBaseModel(data: orders, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "خطأ في جلب طلبات خط السير",
      );
    }
  }

  /// تعديل خط سير
  Future<RemoteBaseModel<OrderPathData>> updateOrderPath({
    required String pathId,
    String? name,
    List<String>? regions,
    String? workflowSlug,
    int? triggerStepNumber,
    bool? autoAssign,
    Map<String, dynamic>? schedule,
    bool? isActive,
  }) async {
    JDRepoConsole.info(
      "Updating order path in repo: $pathId",
      context: LogContext(module: "OrderPathRepo", method: "updateOrderPath"),
    );

    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (regions != null) 'regions': regions,
      if (workflowSlug != null) 'workflowSlug': workflowSlug,
      if (triggerStepNumber != null) 'triggerStepNumber': triggerStepNumber,
      if (autoAssign != null) 'autoAssign': autoAssign,
      if (schedule != null) 'schedule': schedule,
      if (isActive != null) 'isActive': isActive,
    };

    final result = await _source.updateOrderPath(
      pathId: pathId,
      body: body,
    );

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
      );
    }

    try {
      final path = OrderPathData.fromJson(result.data as Map<String, dynamic>);
      return RemoteBaseModel(data: path, status: StatusModel.success);
    } catch (e) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: "خطأ في تعديل خط السير",
      );
    }
  }

  /// حذف خط سير
  Future<RemoteBaseModel<bool>> deleteOrderPath(String pathId) async {
    JDRepoConsole.info(
      "Deleting order path in repo: $pathId",
      context: LogContext(module: "OrderPathRepo", method: "deleteOrderPath"),
    );

    final result = await _source.deleteOrderPath(pathId);

    if (result.error != null) {
      return RemoteBaseModel(
        status: StatusModel.error,
        message: result.error?.message,
        data: false,
      );
    }

    JDRepoConsole.success(
      "Order path deleted successfully in repo",
      context: LogContext(module: "OrderPathRepo", method: "deleteOrderPath"),
    );
    return RemoteBaseModel(data: true, status: StatusModel.success);
  }
}
