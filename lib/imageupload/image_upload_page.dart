import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:pdfx/pdfx.dart';

import 'package:test/imageupload/dto/businees_validate_req_dto.dart';
import 'package:test/imageupload/dto/nice_user_resp_dto.dart';
import 'package:test/imageupload/dto/store_info_req_dto.dart';
import 'package:test/imageupload/image_upload_viewmodel.dart';

class ImageUploadPage extends ConsumerWidget {
  const ImageUploadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageUploadProvider);
    final notifier = ref.read(imageUploadProvider.notifier);

    // 상태가 변경될 때마다 호출
    ref.listen<ImageUploadState>(imageUploadProvider, (previous, next) {
      if (next.imageData != null &&
          next.isLoading == true &&
          previous?.imageData != next.imageData) {
        _uploadFileAndOcr(next, context, notifier);
        notifier.updateLoadingState(false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Center(
        child: ListView(
          children: [
            state.imageData == null
                ? const Text('이미지를 선택하세요')
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(state.imageData!, fit: BoxFit.cover),
                  ),
            ElevatedButton(
              onPressed: () async {
                // 업로드 링크 받기
                await _getPresignedUrl(notifier);
              },
              child: const Text('링크 받기'),
            ),
            state.ocrText == null ? Container() : Text(state.ocrText!),
            ElevatedButton(
              onPressed: () async {
                // 사진 파일 선택, 이미지 데이터 처리
                await _pickAndProcessFileAndUploadAndOcr(
                    context, notifier, state);
              },
              child: const Text('앨범에서 사진 선택하기'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 가게 등록 완료하기
                await registerStore(context, notifier, state);
              },
              child: const Text('가게 등록 완료하기 '),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////////////////
//////////////////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////////////////

// 스낵바 모듈
void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

// pdf 파일 이미지 변환 처리
Future<Uint8List> _pdfFileProcess(File file) async {
  final doc = await PdfDocument.openFile(file.path);
  final page = await doc.getPage(1);

  Uint8List? imageData = await page
      .render(
        width: page.width * 1,
        height: page.height * 1,
        format: PdfPageImageFormat.jpeg, // JPEG 포맷으로 렌더링
        backgroundColor: '#FFFFFF', // 배경색 지정
        cropRect: Rect.fromLTWH(0, 0, page.width, page.height), // 전체 페이지 크롭
      )
      .then((value) => value?.bytes);

  return imageData!;
}

// 파일 업로드 그리고 텍스트 추출
Future<void> _uploadFileAndOcr(
  ImageUploadState state,
  BuildContext context,
  ImageUploadViewModel notifier,
) async {
  String ocrText = '';
  notifier.updateOcrText(ocrText);
  if (state.imageData != null && state.niceUserRespDto != null) {
    try {
      final uploadRequest =
          http.Request('PUT', Uri.parse(state.niceUserRespDto!.presignedUrl))
            ..headers['Content-Type'] = 'application/octet-stream'
            ..bodyBytes = state.imageData!;

      // 업로드와 텍스트 추출을 동시에 실행
      final results = await Future.wait(
          [uploadRequest.send(), ocrApiRequest(state.imageData!)]);

      final response = results[0] as http.StreamedResponse;
      final ocrText = results[1] as String;

      // 업로드 결과 처리
      if (response.statusCode == 200) {
        _showSnackBar(context, '파일 업로드 성공');
      } else {
        _showSnackBar(context, '파일 업로드 실패');
      }

      // 텍스트 추출 결과 처리
      if (ocrText.isNotEmpty && state.storeInfoReqDto != null) {
        final ocrJson = extractObjectFromText(ocrText);

        StoreInfoReqDto storeInfoReqDto =
            StoreInfoReqDto.fromJsonOCR(ocrJson, state.storeInfoReqDto!);
        notifier.updateStoreInfoReqDto(storeInfoReqDto);
        await notifier.updateOcrText(ocrText);

        // 사업자 등록증 검증 요청 객체 생성 - 나중엔 상태에서 로그인 사용자 이름을 가져와야함
        BusinessValidateReqDto businessValidateReqDto = BusinessValidateReqDto(
            ownerName: "신예진",
            businessNumber: storeInfoReqDto.businessNumber,
            startDate: storeInfoReqDto.startDate.toString());

        // 사업자 등록증 검증 요청
        await _businessValidate(
            notifier, context, state, businessValidateReqDto);
      } else {
        _showSnackBar(context, '텍스트 추출 실패');
      }
    } catch (e) {
      _showSnackBar(context, '업로드 중 오류 발생');
    }
    return;
  } else {
    _showSnackBar(context, '이미지를 선택하세요');
  }
}

// openai 텍스트 추출 후 json 가공
String extractObjectFromText(String ocrText) {
  ocrText = ocrText.replaceFirst('json', '').replaceAll('```', '').trim();
  return ocrText;
}

// 파일 로드해서 화면에 표시 상태 변경
Future<void> _pickAndProcessFileAndUploadAndOcr(BuildContext context,
    ImageUploadViewModel notifier, ImageUploadState state) async {
  try {
    notifier.updateLoadingState(true);

    final FilePickerResult? picker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      withData: true,
    );

    if (picker != null && picker.files.isNotEmpty) {
      final file = picker.files.first;

      if (['jpg', 'jpeg', 'png'].contains(file.extension)) {
        await notifier.updateImageData(file.bytes!);
      } else if (file.extension == 'pdf') {
        Uint8List pdfImageData = await _pdfFileProcess(File(file.path!));
        await notifier.updateImageData(pdfImageData);
      }
    } else {
      _showSnackBar(context, '이미지를 선택하세요');
    }
  } catch (e) {
    _showSnackBar(context, '이미지 선택 오류');
  }
}

// 업로드 권한 url 받아오기
Future<void> _getPresignedUrl(ImageUploadViewModel notifier) async {
  try {
    final response = await http.patch(
      Uri.parse(
          'http://10.0.2.2:3000/users/1efa7a79-8c2b-6950-a8de-e15fe4870ef6'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": "김성훈",
        "gender": "남",
        "birthDate": "2011.10.02",
        "phone": "010-3422-0935",
        "email": "chugue85@gmail.com"
      }),
    );

    if (response.statusCode == 201) {
      final result = jsonDecode(response.body)['data'];
      notifier.updateNiceUserRespDto(NiceUserRespDto.fromJson(result));
    } else {
      throw Exception(
          'Failed to get presigned URL with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Presigned URL 요청 중 오류 발생');
  }
}

// openai 이미지 텍스트 추출
Future<String> ocrApiRequest(Uint8List imageBytes) async {
  img.Image? image;
  image = img.decodeImage(imageBytes);
  final resizedImage = img.copyResize(image!, width: 1024); // 너비를 1000으로 조정
  final compressedImageBytes =
      Uint8List.fromList(img.encodeJpg(resizedImage, quality: 100));

  final base64Image = base64Encode(compressedImageBytes);
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
    },
    body: jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  '너는 뛰어난 세무사야. 이 이미지는 사업자 등록증이고, 여기서 사업자 등록번호, 개업연월일, 사업장 주소, 상호명(법인명,단체명)을 추출해서 json으로만 반환해야해.\n너가 채워야 할 필드는 businessNumber, startDate, baseAddress, detailAddress, storeName 매칭해서 한글로 반환해야해.\n그리고 보통 주소는 기본주소와 상세주소로 나누어 지는데, 주소가 --서울특별시 종로구 종로 6, 5층 스타필드 빌리지(서린동, 광화문우체국)-- 이런식으로 되어있으면 \n기본주소는 --서울특별시 종로구 종로 6--이고 상세주소는 --5층 스타필드 빌리지(서린동, 광화문우체국)-- 이런식으로 나누어져야해 \n그리고 모든 주소는 한국에서 실존하는 지역명이어야 해. 그리고 개업연월을은 yyyy/mm/dd 형식이어야 해 '
            },
            {
              'type': 'image_url',
              'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
            }
          ],
          'detail': 'high',
        }
      ],
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    Logger().i('Total tokens: ${data['usage']['total_tokens']}');
    Logger().i(data['choices'][0]['message']['content']);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to extract text: ${response.body}');
  }
}

// 가게 등록 완료하기
Future<void> registerStore(BuildContext context, ImageUploadViewModel notifier,
    ImageUploadState state) async {
  try {
    Logger().d('가게 등록 요청 시도');
    if (state.storeInfoReqDto != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/store'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(state.storeInfoReqDto?.toMap()),
      );

      if (response.statusCode == 201) {
        _showSnackBar(context, '가게 등록 성공');
      } else {
        _showSnackBar(context, '가게 등록 실패');
      }
    } else {
      _showSnackBar(context, '가게 등록 정보를 입력하세요');
    }
  } catch (e) {
    throw Exception('가게 등록 중 오류 발생');
  }
}

// 사업자 등록증 검증
Future<void> _businessValidate(
    ImageUploadViewModel notifier,
    BuildContext context,
    ImageUploadState state,
    BusinessValidateReqDto businessValidateReqDto) async {
  try {
    Logger().d('사업자 등록증 검증 요청 시도');
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/store/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'businessNumber': businessValidateReqDto.businessNumber,
        'startDate': businessValidateReqDto.startDate,
        'ownerName': businessValidateReqDto.ownerName,
      }),
    );

    Logger().d(response.body);
    if (response.statusCode == 201) {
      notifier.updateIsBusinessValidate(true);
      _showSnackBar(context, '사업자 등록증 검증 성공');
    } else {
      notifier.updateIsBusinessValidate(false);
      _showSnackBar(context, '사업자 등록증 검증 실패');

      // 사업자 등록증 삭제 요청
      _deleteBizLisenceRequest(state, context);
    }
  } catch (e) {
    throw Exception('사업자 등록증 검증 중 오류 발생');
  }
}

// 사업자 등록증 삭제 요청
Future<void> _deleteBizLisenceRequest(
    ImageUploadState state, BuildContext context) async {
  Logger().d('사업자 등록증 삭제 요청 시도');
  try {
    if (state.niceUserRespDto?.bizLicenseUrl != null) {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:3000/file-api/biz-license')
            .replace(queryParameters: {
          'url': state.niceUserRespDto?.bizLicenseUrl,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar(context, '사업자 등록증 삭제 성공');
      } else {
        _showSnackBar(context, '사업자 등록증 삭제 실패');
      }
    }
  } catch (e) {
    throw Exception('사업자 등록증 검증 중 오류 발생');
  }
}
