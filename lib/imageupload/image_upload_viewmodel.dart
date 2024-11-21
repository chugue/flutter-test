import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/imageupload/dto/nice_user_resp_dto.dart';
import 'package:test/imageupload/dto/user_info_state_dto.dart';

class ImageUploadState {
  final UserInfoStateDto? userInfoStateDto;
  final NiceUserRespDto? niceUserRespDto;
  final Uint8List? imageData;
  final String? ocrText;
  final bool? isLoading;

  ImageUploadState({
    required this.userInfoStateDto,
    required this.niceUserRespDto,
    required this.imageData,
    required this.ocrText,
    required this.isLoading,
  });

  ImageUploadState copyWith({
    UserInfoStateDto? userInfoStateDto,
    NiceUserRespDto? niceUserRespDto,
    Uint8List? imageData,
    String? ocrText,
    bool? isLoading,
  }) {
    return ImageUploadState(
      userInfoStateDto: userInfoStateDto ?? this.userInfoStateDto,
      niceUserRespDto: niceUserRespDto ?? this.niceUserRespDto,
      imageData: imageData ?? this.imageData,
      ocrText: ocrText ?? this.ocrText,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ImageUploadViewModel extends StateNotifier<ImageUploadState> {
  ImageUploadViewModel()
      : super(ImageUploadState(
          userInfoStateDto: null,
          niceUserRespDto: null,
          imageData: null,
          ocrText: null,
          isLoading: false,
        ));

  void updateUserInfo(UserInfoStateDto newUserInfo) {
    state = state.copyWith(userInfoStateDto: newUserInfo);
  }

  Future<void> updateImageData(Uint8List newImageData) async {
    state = state.copyWith(imageData: newImageData);
  }

  void updateNiceUserRespDto(NiceUserRespDto newNiceUserRespDto) {
    Logger().d(newNiceUserRespDto);
    state = state.copyWith(niceUserRespDto: newNiceUserRespDto);
  }

  Future<void> updateOcrText(String newOcrText) async {
    state = state.copyWith(ocrText: newOcrText);
  }

  void updateLoadingState(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

final imageUploadProvider =
    StateNotifierProvider<ImageUploadViewModel, ImageUploadState>(
  (ref) => ImageUploadViewModel(),
);
