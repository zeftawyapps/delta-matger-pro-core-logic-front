import 'package:matger_pro_core_logic/models/entity_meta.dart';
import 'package:matger_pro_core_logic/utls/type_parser.dart';

/// بيانات خط السير (Order Path)
/// يمثل مسار جغرافي لتوزيع الطلبات تلقائياً
class OrderPathData {
  final String id;
  final String organizationId;
  final String name;
  final List<String> regions;
  final String? workflowSlug;
  final int? triggerStepNumber;
  final bool autoAssign;
  final OrderPathSchedule? schedule;
  final bool isActive;
  final EntityMeta? meta;

  OrderPathData({
    required this.id,
    required this.organizationId,
    required this.name,
    this.regions = const [],
    this.workflowSlug,
    this.triggerStepNumber,
    this.autoAssign = true,
    this.schedule,
    this.isActive = true,
    this.meta,
  });

  factory OrderPathData.fromJson(Map<String, dynamic> json) {
    return OrderPathData(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      organizationId: (json['organizationId'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      regions: (json['regions'] as List?)?.cast<String>() ?? [],
      workflowSlug: json['workflowSlug'] as String?,
      triggerStepNumber: json['triggerStepNumber'] != null
          ? TypeParser.parseInt(json['triggerStepNumber'])
          : null,
      autoAssign: json['autoAssign'] == true,
      schedule: json['schedule'] != null
          ? OrderPathSchedule.fromJson(json['schedule'])
          : null,
      isActive: json['isActive'] != false,
      meta: json['meta'] != null ? EntityMeta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'name': name,
      'regions': regions,
      'workflowSlug': workflowSlug,
      'triggerStepNumber': triggerStepNumber,
      'autoAssign': autoAssign,
      'schedule': schedule?.toJson(),
      'isActive': isActive,
      'meta': meta?.toJson(),
    };
  }
}

/// جدول مواعيد خط السير
/// يتوافق مع RouteSchedule في الباك إند
class OrderPathSchedule {
  final String type; // 'weekly' or 'monthly'
  final List<int> values; // [1, 2, 3] for Mon, Tue, Wed OR [1, 15, 30] for days of month

  OrderPathSchedule({
    this.type = 'weekly',
    this.values = const [],
  });

  factory OrderPathSchedule.fromJson(Map<String, dynamic> json) {
    return OrderPathSchedule(
      type: (json['type'] ?? 'weekly') as String,
      values: (json['values'] as List?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'values': values,
    };
  }
}
