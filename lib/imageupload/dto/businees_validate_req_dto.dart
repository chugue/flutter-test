// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BusinessValidateReqDto {
  final String? businessNumber;
  final String? startDate;
  final String? ownerName;
  BusinessValidateReqDto({
    this.businessNumber,
    this.startDate,
    this.ownerName,
  });

  BusinessValidateReqDto copyWith({
    String? businessNumber,
    String? startDate,
    String? ownerName,
  }) {
    return BusinessValidateReqDto(
      businessNumber: businessNumber ?? this.businessNumber,
      startDate: startDate ?? this.startDate,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'businessNumber': businessNumber,
      'startDate': startDate,
      'ownerName': ownerName,
    };
  }

  factory BusinessValidateReqDto.fromMap(Map<String, dynamic> map) {
    return BusinessValidateReqDto(
      businessNumber: map['businessNumber'] != null
          ? map['businessNumber'] as String
          : null,
      startDate: map['startDate'] != null ? map['startDate'] as String : null,
      ownerName: map['ownerName'] != null ? map['ownerName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessValidateReqDto.fromJson(String source) =>
      BusinessValidateReqDto.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BusinessValidateReqDto(businessNumber: $businessNumber, startDate: $startDate, ownerName: $ownerName)';

  @override
  bool operator ==(covariant BusinessValidateReqDto other) {
    if (identical(this, other)) return true;

    return other.businessNumber == businessNumber &&
        other.startDate == startDate &&
        other.ownerName == ownerName;
  }

  @override
  int get hashCode =>
      businessNumber.hashCode ^ startDate.hashCode ^ ownerName.hashCode;
}
