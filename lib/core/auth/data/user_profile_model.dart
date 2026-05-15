import 'package:matger_pro_core_logic/core/auth/data/user_model.dart';
import 'package:matger_pro_core_logic/core/orgnization/data/organization_model.dart';

class UserProfileModel extends UserDataDetailsModel {
  final String? website;
  final SocialLinks? socialLinks;
  final LocationData? location;
  final bool isActiveProfile;

  UserProfileModel({
    required super.userId,
    required super.username,
    required super.email,
    required super.phone,
    super.roles,
    super.address,
    super.organizationId,
    super.dateOfBirth,
    super.bio,
    super.avatarUrl,
    super.countryId,
    super.governorateId,
    super.cityId,
    super.additionalInfo,
    super.meta,
    this.website,
    this.socialLinks,
    this.location,
    this.isActiveProfile = true,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final parent = UserDataDetailsModel.fromJson(json);
    return UserProfileModel(
      userId: parent.userId,
      username: parent.username,
      email: parent.email,
      phone: parent.phone,
      roles: parent.roles,
      address: parent.address,
      organizationId: parent.organizationId,
      dateOfBirth: parent.dateOfBirth,
      bio: parent.bio,
      avatarUrl: parent.avatarUrl,
      countryId: parent.countryId,
      governorateId: parent.governorateId,
      cityId: parent.cityId,
      additionalInfo: parent.additionalInfo,
      meta: parent.meta,
      website: json['website'] as String?,
      socialLinks: json['socialLinks'] != null
          ? SocialLinks.fromJson(json['socialLinks'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? LocationData.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      isActiveProfile: json['isActive'] as bool? ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map.addAll({
      'website': website,
      'socialLinks': socialLinks?.toJson(),
      'location': location?.toJson(),
      'isActive': isActiveProfile,
    });
    return map;
  }
}

class SocialLinks {
  final String? twitter;
  final String? facebook;

  SocialLinks({this.twitter, this.facebook});

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      twitter: json['twitter'] as String?,
      facebook: json['facebook'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'twitter': twitter, 'facebook': facebook};
  }
}
