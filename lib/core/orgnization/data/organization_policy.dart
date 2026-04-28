class OrganizationPolicy {
  final String id;
  final LogisticsPolicy? logistics;
  final ShippingPolicy? shipping;
  final SalesRulesPolicy? salesRules;
  final DateTime? createdAt; // 🟢 الحقل الجديد
  final DateTime? updatedAt; // 🟢 الحقل الجديد
  final int? v; // 🟢 الحقل الجديد (__v)

  OrganizationPolicy({
    required this.id,
    this.logistics,
    this.shipping,
    this.salesRules,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory OrganizationPolicy.fromJson(Map<String, dynamic> json) {
    return OrganizationPolicy(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      logistics: json['logistics'] != null
          ? LogisticsPolicy.fromJson(Map<String, dynamic>.from(json['logistics']))
          : null,
      shipping: json['shipping'] != null
          ? ShippingPolicy.fromJson(Map<String, dynamic>.from(json['shipping']))
          : null,
      salesRules: json['salesRules'] != null
          ? SalesRulesPolicy.fromJson(
              Map<String, dynamic>.from(json['salesRules']),
            )
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      v: json['__v'] != null ? (json['__v'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (logistics != null) 'logistics': logistics!.toJson(),
      if (shipping != null) 'shipping': shipping!.toJson(),
      if (salesRules != null) 'salesRules': salesRules!.toJson(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }
}

class LogisticsPolicy {
  final List<String>? allowedUnits;
  final String? defaultUnit;
  final String? currency;
  final bool? enableVat;
  final num? taxPercentage;
  final bool? enableStockManagement;

  LogisticsPolicy({
    this.allowedUnits,
    this.defaultUnit,
    this.currency,
    this.enableVat,
    this.taxPercentage,
    this.enableStockManagement,
  });

  factory LogisticsPolicy.fromJson(Map<String, dynamic> json) {
    return LogisticsPolicy(
      allowedUnits: json['allowedUnits'] != null
          ? List<String>.from(json['allowedUnits'])
          : null,
      defaultUnit: json['defaultUnit'],
      currency: json['currency'],
      enableVat: json['enableVat'],
      taxPercentage: json['taxPercentage'],
      enableStockManagement: json['enableStockManagement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (allowedUnits != null) 'allowedUnits': allowedUnits,
      if (defaultUnit != null) 'defaultUnit': defaultUnit,
      if (currency != null) 'currency': currency,
      if (enableVat != null) 'enableVat': enableVat,
      if (taxPercentage != null) 'taxPercentage': taxPercentage,
      if (enableStockManagement != null)
        'enableStockManagement': enableStockManagement,
    };
  }
}

class ShippingPolicy {
  final num? defaultFee;
  final bool? freeShippingEnabled;
  final Map<String, num>? feesByGovernorate;

  ShippingPolicy({
    this.defaultFee,
    this.freeShippingEnabled,
    this.feesByGovernorate,
  });

  factory ShippingPolicy.fromJson(Map<String, dynamic> json) {
    return ShippingPolicy(
      defaultFee: json['defaultFee'],
      freeShippingEnabled: json['freeShippingEnabled'],
      feesByGovernorate: json['feesByGovernorate'] != null
          ? Map<String, num>.from(json['feesByGovernorate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (defaultFee != null) 'defaultFee': defaultFee,
      if (freeShippingEnabled != null) 'freeShippingEnabled': freeShippingEnabled,
      if (feesByGovernorate != null) 'feesByGovernorate': feesByGovernorate,
    };
  }
}

class SalesRulesPolicy {
  final bool? autoDiscount;
  final num? wholesaleDiscount;
  final num? agentDiscount;
  final List<InvoiceSlice>? invoiceSlices;

  SalesRulesPolicy({
    this.autoDiscount,
    this.wholesaleDiscount,
    this.agentDiscount,
    this.invoiceSlices,
  });

  factory SalesRulesPolicy.fromJson(Map<String, dynamic> json) {
    return SalesRulesPolicy(
      autoDiscount: json['autoDiscount'],
      wholesaleDiscount: json['wholesaleDiscount'],
      agentDiscount: json['agentDiscount'],
      invoiceSlices: json['invoiceSlices'] != null
          ? (json['invoiceSlices'] as List)
              .map((i) => InvoiceSlice.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (autoDiscount != null) 'autoDiscount': autoDiscount,
      if (wholesaleDiscount != null) 'wholesaleDiscount': wholesaleDiscount,
      if (agentDiscount != null) 'agentDiscount': agentDiscount,
      if (invoiceSlices != null)
        'invoiceSlices': invoiceSlices!.map((i) => i.toJson()).toList(),
    };
  }
}

class InvoiceSlice {
  final num? minAmount;
  final num? discountAmount;

  InvoiceSlice({
    this.minAmount,
    this.discountAmount,
  });

  factory InvoiceSlice.fromJson(Map<String, dynamic> json) {
    return InvoiceSlice(
      minAmount: json['minAmount'],
      discountAmount: json['discountAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (minAmount != null) 'minAmount': minAmount,
      if (discountAmount != null) 'discountAmount': discountAmount,
    };
  }
}

