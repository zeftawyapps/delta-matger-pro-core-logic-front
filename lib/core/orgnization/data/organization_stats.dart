class OrganizationStats {
  final int total;
  final int active;
  final int inactive;
  final int templates;

  OrganizationStats({
    required this.total,
    required this.active,
    required this.inactive,
    required this.templates,
  });

  factory OrganizationStats.fromJson(Map<String, dynamic> json) {
    return OrganizationStats(
      total: json['total'] as int? ?? 0,
      active: json['active'] as int? ?? 0,
      inactive: json['inactive'] as int? ?? 0,
      templates: json['templates'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'templates': templates,
    };
  }
}
