class OrganizationPolicy {
  final String id;
  final LogisticsPolicy? logistics;
  final ShippingPolicy? shipping;
  final SalesRulesPolicy? salesRules;

  OrganizationPolicy({
    required this.id,
    this.logistics,
    this.shipping,
    this.salesRules,
  });

  factory OrganizationPolicy.fromJson(Map<String, dynamic> json) {
    return OrganizationPolicy(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      logistics: json['logistics'] != null ? LogisticsPolicy.fromJson(Map<String, dynamic>.from(json['logistics'])) : null,
      shipping: json['shipping'] != null ? ShippingPolicy.fromJson(Map<String, dynamic>.from(json['shipping'])) : null,
      salesRules: json['salesRules'] != null ? SalesRulesPolicy.fromJson(Map<String, dynamic>.from(json['salesRules'])) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (logistics != null) 'logistics': logistics!.toJson(),
      if (shipping != null) 'shipping': shipping!.toJson(),
      if (salesRules != null) 'salesRules': salesRules!.toJson(),
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
      allowedUnits: json['allowedUnits'] != null ? List<String>.from(json['allowedUnits']) : null,
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
      if (enableStockManagement != null) 'enableStockManagement': enableStockManagement,
    };
  }
}

class ShippingPolicy {
  final num defaultFee;
  final bool freeShippingEnabled;
  final Map<String, num> feesByGovernorate;

  ShippingPolicy({
    required this.defaultFee,
    required this.freeShippingEnabled,
    required this.feesByGovernorate,
  });

  factory ShippingPolicy.fromJson(Map<String, dynamic> json) {
    return ShippingPolicy(
      defaultFee: json['defaultFee'] ?? 50,
      freeShippingEnabled: json['freeShippingEnabled'] ?? false,
      feesByGovernorate: json['feesByGovernorate'] != null 
          ? Map<String, num>.from(json['feesByGovernorate']) 
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultFee': defaultFee,
      'freeShippingEnabled': freeShippingEnabled,
      'feesByGovernorate': feesByGovernorate,
    };
  }
}

class SalesRulesPolicy {
  final bool autoDiscount;
  final num wholesaleDiscount;
  final num agentDiscount;
  final List<InvoiceSlice> invoiceSlices;

  SalesRulesPolicy({
    required this.autoDiscount,
    required this.wholesaleDiscount,
    required this.agentDiscount,
    required this.invoiceSlices,
  });

  factory SalesRulesPolicy.fromJson(Map<String, dynamic> json) {
    return SalesRulesPolicy(
      autoDiscount: json['autoDiscount'] ?? true,
      wholesaleDiscount: json['wholesaleDiscount'] ?? 0,
      agentDiscount: json['agentDiscount'] ?? 0,
      invoiceSlices: json['invoiceSlices'] != null 
          ? (json['invoiceSlices'] as List).map((i) => InvoiceSlice.fromJson(i)).toList() 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'autoDiscount': autoDiscount,
      'wholesaleDiscount': wholesaleDiscount,
      'agentDiscount': agentDiscount,
      'invoiceSlices': invoiceSlices.map((i) => i.toJson()).toList(),
    };
  }
}

class InvoiceSlice {
  final num minAmount;
  final num discountAmount;

  InvoiceSlice({
    required this.minAmount,
    required this.discountAmount,
  });

  factory InvoiceSlice.fromJson(Map<String, dynamic> json) {
    return InvoiceSlice(
      minAmount: json['minAmount'] ?? 0,
      discountAmount: json['discountAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minAmount': minAmount,
      'discountAmount': discountAmount,
    };
  }
}
