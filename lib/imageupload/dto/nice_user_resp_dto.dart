// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NiceUserRespDto {
  final String userInfoId;
  final String email;
  final String bizLicenseUrl;
  final String presignedUrl;

  NiceUserRespDto({
    required this.userInfoId,
    required this.email,
    required this.bizLicenseUrl,
    required this.presignedUrl,
  });

  NiceUserRespDto copyWith({
    String? userInfoId,
    String? email,
    String? bizLicenseUrl,
    String? presignedUrl,
  }) {
    return NiceUserRespDto(
      userInfoId: userInfoId ?? this.userInfoId,
      email: email ?? this.email,
      bizLicenseUrl: bizLicenseUrl ?? this.bizLicenseUrl,
      presignedUrl: presignedUrl ?? this.presignedUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userInfoId': userInfoId,
      'email': email,
      'bizLicenseUrl': bizLicenseUrl,
      'presignedUrl': presignedUrl,
    };
  }

  factory NiceUserRespDto.fromMap(Map<String, dynamic> data) {
    return NiceUserRespDto(
      userInfoId: data['userInfoId'] as String,
      email: data['email'] as String,
      bizLicenseUrl: data['bizLicenseUrl'] as String,
      presignedUrl: data['presignedUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NiceUserRespDto.fromJson(Map<String, dynamic> data) =>
      NiceUserRespDto.fromMap(data);

  @override
  String toString() {
    return 'NiceUserRespDto(userInfoId: $userInfoId, email: $email, bizLicenseUrl: $bizLicenseUrl, presignedUrl: $presignedUrl)';
  }

  @override
  bool operator ==(covariant NiceUserRespDto other) {
    if (identical(this, other)) return true;

    return other.userInfoId == userInfoId &&
        other.email == email &&
        other.bizLicenseUrl == bizLicenseUrl &&
        other.presignedUrl == presignedUrl;
  }

  @override
  int get hashCode {
    return userInfoId.hashCode ^
        email.hashCode ^
        bizLicenseUrl.hashCode ^
        presignedUrl.hashCode;
  }
}
