import 'package:JoDija_reposatory/utilis/models/base_data_model.dart';
import 'package:matger_pro_core_logic/utls/type_parser.dart';

class UserMeta {
  final String userId;
  final String? userName;
  final String? userEmail;

  UserMeta({required this.userId, this.userName, this.userEmail});

  factory UserMeta.fromJson(Map<String, dynamic> json) {
    return UserMeta(
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'userName': userName, 'userEmail': userEmail};
  }
}

class EntityMeta extends BaseEntityDataModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime? deletedAt;
  final UserMeta? user;

  EntityMeta({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.deletedAt,
    this.user,
  });

  factory EntityMeta.fromJson(Map<String, dynamic> json) {
    return EntityMeta(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isActive: TypeParser.parseBool(json['isActive'], true),
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'].toString())
          : null,
      user: json['user'] != null ? UserMeta.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'deletedAt': deletedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
