// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserInfoStateDto {
  final String presignedUrl;
  final String userInfoId;
  final String bizLicenseUrl;
  final String baseAddress;
  final String detailAddress;
  final String storeName;
  final String branchName;
  final bool isMainBranch;
  final String storeCategory;
  final String storePhone;
  final String openningHour;
  final bool is24hOpen;

  UserInfoStateDto({
    this.presignedUrl = '',
    this.userInfoId = '',
    this.bizLicenseUrl = '',
    this.baseAddress = '',
    this.detailAddress = '',
    this.storeName = '',
    this.branchName = '',
    this.isMainBranch = false,
    this.storeCategory = '',
    this.storePhone = '',
    this.openningHour = '',
    this.is24hOpen = false,
  });

  UserInfoStateDto copyWith({
    String? presignedUrl,
    String? userInfoId,
    String? bizLicenseUrl,
    String? baseAddress,
    String? detailAddress,
    String? storeName,
    String? branchName,
    bool? isMainBranch,
    String? storeCategory,
    String? storePhone,
    String? openningHour,
    bool? is24hOpen,
  }) {
    return UserInfoStateDto(
      presignedUrl: presignedUrl ?? this.presignedUrl,
      userInfoId: userInfoId ?? this.userInfoId,
      bizLicenseUrl: bizLicenseUrl ?? this.bizLicenseUrl,
      baseAddress: baseAddress ?? this.baseAddress,
      detailAddress: detailAddress ?? this.detailAddress,
      storeName: storeName ?? this.storeName,
      branchName: branchName ?? this.branchName,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      storeCategory: storeCategory ?? this.storeCategory,
      storePhone: storePhone ?? this.storePhone,
      openningHour: openningHour ?? this.openningHour,
      is24hOpen: is24hOpen ?? this.is24hOpen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'presignedUrl': presignedUrl,
      'userInfoId': userInfoId,
      'bizLicenseUrl': bizLicenseUrl,
      'baseAddress': baseAddress,
      'detailAddress': detailAddress,
      'storeName': storeName,
      'branchName': branchName,
      'isMainBranch': isMainBranch,
      'storeCategory': storeCategory,
      'storePhone': storePhone,
      'openningHour': openningHour,
      'is24hOpen': is24hOpen,
    };
  }

  factory UserInfoStateDto.fromMap(Map<String, dynamic> map) {
    return UserInfoStateDto(
      presignedUrl: map['presignedUrl'] as String,
      userInfoId: map['userInfoId'] as String,
      bizLicenseUrl: map['bizLicenseUrl'] as String,
      baseAddress: map['baseAddress'] as String,
      detailAddress: map['detailAddress'] as String,
      storeName: map['storeName'] as String,
      branchName: map['branchName'] as String,
      isMainBranch: map['isMainBranch'] as bool,
      storeCategory: map['storeCategory'] as String,
      storePhone: map['storePhone'] as String,
      openningHour: map['openningHour'] as String,
      is24hOpen: map['is24hOpen'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfoStateDto.fromJson(String source) =>
      UserInfoStateDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInfoStateDto(presignedUrl: $presignedUrl, userInfoId: $userInfoId, bizLicenseUrl: $bizLicenseUrl, baseAddress: $baseAddress, detailAddress: $detailAddress, storeName: $storeName, branchName: $branchName, isMainBranch: $isMainBranch, storeCategory: $storeCategory, storePhone: $storePhone, openningHour: $openningHour, is24hOpen: $is24hOpen)';
  }

  @override
  bool operator ==(covariant UserInfoStateDto other) {
    if (identical(this, other)) return true;

    return other.presignedUrl == presignedUrl &&
        other.userInfoId == userInfoId &&
        other.bizLicenseUrl == bizLicenseUrl &&
        other.baseAddress == baseAddress &&
        other.detailAddress == detailAddress &&
        other.storeName == storeName &&
        other.branchName == branchName &&
        other.isMainBranch == isMainBranch &&
        other.storeCategory == storeCategory &&
        other.storePhone == storePhone &&
        other.openningHour == openningHour &&
        other.is24hOpen == is24hOpen;
  }

  @override
  int get hashCode {
    return presignedUrl.hashCode ^
        userInfoId.hashCode ^
        bizLicenseUrl.hashCode ^
        baseAddress.hashCode ^
        detailAddress.hashCode ^
        storeName.hashCode ^
        branchName.hashCode ^
        isMainBranch.hashCode ^
        storeCategory.hashCode ^
        storePhone.hashCode ^
        openningHour.hashCode ^
        is24hOpen.hashCode;
  }
}
