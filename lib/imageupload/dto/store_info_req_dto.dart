// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class StoreInfoReqDto {
  final String? userInfoId;
  final String? businessNumber;
  final String? bizLicenseUrl;
  final String? baseAddress;
  final String? detailAddress;
  final String? storeName;
  final String? branchName;
  final String? storeCategory;
  final String? storePhone;
  final DateTime? startDate;
  final String? openingHour;
  final bool? isMainBranch;
  final bool? is24Open;
  final bool? isLegalAgreed;

  StoreInfoReqDto({
    this.userInfoId,
    this.businessNumber,
    this.bizLicenseUrl,
    this.baseAddress,
    this.detailAddress,
    this.storeName,
    this.branchName,
    this.storeCategory,
    this.storePhone,
    this.startDate,
    this.openingHour,
    this.isMainBranch,
    this.is24Open,
    this.isLegalAgreed,
  });

  StoreInfoReqDto copyWith({
    String? userInfoId,
    String? businessNumber,
    String? bizLicenseUrl,
    String? baseAddress,
    String? detailAddress,
    String? storeName,
    String? branchName,
    String? storeCategory,
    String? storePhone,
    DateTime? startDate,
    String? openingHour,
    bool? isMainBranch,
    bool? is24Open,
    bool? isLegalAgreed,
  }) {
    return StoreInfoReqDto(
      userInfoId: userInfoId ?? this.userInfoId,
      businessNumber: businessNumber ?? this.businessNumber,
      bizLicenseUrl: bizLicenseUrl ?? this.bizLicenseUrl,
      baseAddress: baseAddress ?? this.baseAddress,
      detailAddress: detailAddress ?? this.detailAddress,
      storeName: storeName ?? this.storeName,
      branchName: branchName ?? this.branchName,
      storeCategory: storeCategory ?? this.storeCategory,
      storePhone: storePhone ?? this.storePhone,
      startDate: startDate ?? this.startDate,
      openingHour: openingHour ?? openingHour,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      is24Open: is24Open ?? is24Open,
      isLegalAgreed: isLegalAgreed ?? this.isLegalAgreed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userInfoId': userInfoId,
      'businessNumber': businessNumber,
      'bizLicenseUrl': bizLicenseUrl,
      'baseAddress': baseAddress,
      'detailAddress': detailAddress,
      'storeName': storeName,
      'branchName': branchName,
      'storeCategory': storeCategory,
      'storePhone': storePhone,
      'startDate': startDate?.millisecondsSinceEpoch,
      'openingHour': openingHour,
      'isMainBranch': isMainBranch,
      'is24Open': is24Open,
      'isLegalAgreed': isLegalAgreed,
    };
  }

  factory StoreInfoReqDto.fromMap(Map<String, dynamic> map) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    return StoreInfoReqDto(
      userInfoId:
          map['userInfoId'] != null ? map['userInfoId'] as String : null,
      businessNumber: map['businessNumber'] != null
          ? map['businessNumber'] as String
          : null,
      bizLicenseUrl:
          map['bizLicenseUrl'] != null ? map['bizLicenseUrl'] as String : null,
      baseAddress:
          map['baseAddress'] != null ? map['baseAddress'] as String : null,
      detailAddress:
          map['detailAddress'] != null ? map['detailAddress'] as String : null,
      storeName: map['storeName'] != null ? map['storeName'] as String : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      storeCategory:
          map['storeCategory'] != null ? map['storeCategory'] as String : '카페',
      storePhone: map['storePhone'] != null
          ? map['storePhone'] as String
          : '0507-1234-5678',
      startDate: map['startDate'] != null
          ? dateFormat.parse(map['startDate'] as String)
          : null,
      openingHour:
          map['openingHour'] != null ? map['openingHour'] as String : '09:00',
      isMainBranch:
          map['isMainBranch'] != null ? map['isMainBranch'] as bool : true,
      is24Open: map['is24Open'] != null ? map['is24Open'] as bool : false,
      isLegalAgreed:
          map['isLegalAgreed'] != null ? map['isLegalAgreed'] as bool : false,
    );
  }

  factory StoreInfoReqDto.fromMapOCR(
      Map<String, dynamic> map, StoreInfoReqDto previousState) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    return previousState.copyWith(
      businessNumber: map['businessNumber'] != null
          ? map['businessNumber'] as String
          : null,
      baseAddress:
          map['baseAddress'] != null ? map['baseAddress'] as String : null,
      detailAddress:
          map['detailAddress'] != null ? map['detailAddress'] as String : null,
      storeName: map['storeName'] != null ? map['storeName'] as String : null,
      branchName:
          map['branchName'] != null ? map['branchName'] as String : null,
      storeCategory:
          map['storeCategory'] != null ? map['storeCategory'] as String : '카페',
      storePhone: map['storePhone'] != null
          ? map['storePhone'] as String
          : '0507-1234-5678',
      startDate: map['startDate'] != null
          ? dateFormat.parse(map['startDate'] as String)
          : null,
      openingHour:
          map['openingHour'] != null ? map['openingHour'] as String : '09:00',
      isMainBranch:
          map['isMainBranch'] != null ? map['isMainBranch'] as bool : true,
      is24Open: map['is24Open'] != null ? map['is24Open'] as bool : false,
      isLegalAgreed:
          map['isLegalAgreed'] != null ? map['isLegalAgreed'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInfoReqDto.fromJson(String source) =>
      StoreInfoReqDto.fromMap(json.decode(source) as Map<String, dynamic>);

  factory StoreInfoReqDto.fromJsonOCR(
          String source, StoreInfoReqDto previousState) =>
      StoreInfoReqDto.fromMapOCR(
          json.decode(source) as Map<String, dynamic>, previousState);

  @override
  String toString() {
    return 'StoreInfoReqDto(userInfoId: $userInfoId, businessNumber: $businessNumber, bizLicenseUrl: $bizLicenseUrl, baseAddress: $baseAddress, detailAddress: $detailAddress, storeName: $storeName, branchName: $branchName, storeCategory: $storeCategory, storePhone: $storePhone, startDate: $startDate, openningHour: $openingHour, isMainBranch: $isMainBranch, is24hOpen: $is24Open)';
  }

  @override
  bool operator ==(covariant StoreInfoReqDto other) {
    if (identical(this, other)) return true;

    return other.userInfoId == userInfoId &&
        other.businessNumber == businessNumber &&
        other.bizLicenseUrl == bizLicenseUrl &&
        other.baseAddress == baseAddress &&
        other.detailAddress == detailAddress &&
        other.storeName == storeName &&
        other.branchName == branchName &&
        other.storeCategory == storeCategory &&
        other.storePhone == storePhone &&
        other.startDate == startDate &&
        other.openingHour == openingHour &&
        other.isMainBranch == isMainBranch &&
        other.is24Open == is24Open &&
        other.isLegalAgreed == isLegalAgreed;
  }

  @override
  int get hashCode {
    return userInfoId.hashCode ^
        businessNumber.hashCode ^
        bizLicenseUrl.hashCode ^
        baseAddress.hashCode ^
        detailAddress.hashCode ^
        storeName.hashCode ^
        branchName.hashCode ^
        storeCategory.hashCode ^
        storePhone.hashCode ^
        startDate.hashCode ^
        openingHour.hashCode ^
        isMainBranch.hashCode ^
        is24Open.hashCode ^
        isLegalAgreed.hashCode;
  }
}
