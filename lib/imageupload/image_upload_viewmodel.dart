// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:test/imageupload/dto/businees_validate_req_dto.dart';
import 'package:test/imageupload/dto/nice_user_resp_dto.dart';
import 'package:test/imageupload/dto/store_info_req_dto.dart';

class ImageUploadState {
  final StoreInfoReqDto? storeInfoReqDto;
  final NiceUserRespDto? niceUserRespDto;
  final Uint8List? imageData;
  final String? ocrText;
  final bool? isLoading;
  final bool? isBusinessValidate;
  
  ImageUploadState({
    this.storeInfoReqDto,
    this.niceUserRespDto,
    this.imageData,
    this.ocrText,
    this.isLoading,
    this.isBusinessValidate,
  });

  ImageUploadState copyWith({
    StoreInfoReqDto? storeInfoReqDto,
    NiceUserRespDto? niceUserRespDto,
    BusinessValidateReqDto? businessValidateReqDto,
    Uint8List? imageData,
    String? ocrText,
    bool? isLoading,
    bool? isBusinessValidate,
  }) {
    return ImageUploadState(
      storeInfoReqDto: storeInfoReqDto ?? this.storeInfoReqDto,
      niceUserRespDto: niceUserRespDto ?? this.niceUserRespDto,
      imageData: imageData ?? this.imageData,
      ocrText: ocrText ?? this.ocrText,
      isLoading: isLoading ?? this.isLoading,
      isBusinessValidate: isBusinessValidate ?? this.isBusinessValidate,
    );
  }
}

class ImageUploadViewModel extends StateNotifier<ImageUploadState> {
  ImageUploadViewModel()
      : super(ImageUploadState(
          storeInfoReqDto: null,
          niceUserRespDto: null,
          imageData: null,
          ocrText: null,
          isLoading: false,
          isBusinessValidate: false,
        ));

  void updateStoreInfoReqDto(StoreInfoReqDto storeInfoReqDto) {
    state = state.copyWith(storeInfoReqDto: storeInfoReqDto);
  }

  Future<void> updateImageData(Uint8List newImageData) async {
    state = state.copyWith(imageData: newImageData);
  }

  void updateNiceUserRespDto(NiceUserRespDto newNiceUserRespDto) {
    Logger().d(newNiceUserRespDto.toJson());
    StoreInfoReqDto storeInfoReqDto = StoreInfoReqDto(
        userInfoId: newNiceUserRespDto.userInfoId,
        bizLicenseUrl: newNiceUserRespDto.bizLicenseUrl);

    state = state.copyWith(
      niceUserRespDto: newNiceUserRespDto,
      storeInfoReqDto: storeInfoReqDto,
    );
  }

  Future<void> updateOcrText(String newOcrText) async {
    state = state.copyWith(ocrText: newOcrText);
  }

  void updateLoadingState(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<void> updateBusinessValidateReqDto(
      BusinessValidateReqDto newBusinessValidateReqDto) async {
    state = state.copyWith(businessValidateReqDto: newBusinessValidateReqDto);
  }

  void updateIsBusinessValidate(bool isBusinessValidate) {
    state = state.copyWith(isBusinessValidate: isBusinessValidate);
  }
}

final imageUploadProvider =
    StateNotifierProvider<ImageUploadViewModel, ImageUploadState>(
  (ref) => ImageUploadViewModel(),
);
