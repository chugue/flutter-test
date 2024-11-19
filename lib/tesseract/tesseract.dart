// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:pdfx/pdfx.dart';

// class Tesseract extends StatefulWidget {
//   const Tesseract({super.key});

//   @override
//   _TesseractState createState() => _TesseractState();
// }

// class _TesseractState extends State<Tesseract> {
//   // final FileData _fileData = FileData();
//   String _ocrText = '';
//   List<String> selectList = ["eng", "kor"];
//   Uint8List? imageBytes;
//   String path = "";
//   bool loading = false;
//   late ParsedOCRResult parsedResult;
//   final DateFormat formatter = DateFormat('yyyy/MM/dd');

//   @override
//   void initState() {
//     super.initState();
//     _loadTrainedData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 Expanded(
//                     child: ListView(
//                   children: [
//                     imageBytes == null
//                         ? Container()
//                         : ClipRRect(
//                             borderRadius: BorderRadius.circular(15),
//                             child: Image.memory(imageBytes!)),
//                     loading
//                         ? const Column(children: [CircularProgressIndicator()])
//                         : Text(
//                             _ocrText,
//                           ),
//                   ],
//                 ))
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: kIsWeb
//           ? Container()
//           : FloatingActionButton(
//               onPressed: () {
//                 runFilePiker();
//               },
//               tooltip: 'OCR',
//               child: const Icon(Icons.add),
//             ),
//     );
//   }

//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//   //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////

//   // traineddata 로딩
//   Future<void> _loadTrainedData() async {
//     if (!kIsWeb) {
//       Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
//       if (!dir.existsSync()) {
//         dir.create();
//       }

//       for (String lang in selectList) {
//         bool isInstalled = false;
//         dir.listSync().forEach((element) {
//           String name = element.path.split('/').last;
//           isInstalled |= name == '$lang.traineddata';
//         });
//         print('$lang installed: $isInstalled');
//       }
//     }
//   }

//   // PDF 파일을 이미지로 변환하고 OCR 수행
//   Future<void> _ocrFromPdf(String pdfPath) async {
//     setState(() {
//       loading = true;
//     });
//     try {
//       final doc = await PdfDocument.openFile(pdfPath);
//       final page = await doc.getPage(1);

//       imageBytes = await page
//           .render(
//             width: page.width * 1,
//             height: page.height * 1,
//             format: PdfPageImageFormat.jpeg, // JPEG 포맷으로 렌더링
//             backgroundColor: '#FFFFFF', // 배경색 지정
//             cropRect: Rect.fromLTWH(0, 0, page.width, page.height), // 전체 페이지 크롭
//           )
//           .then((value) => value?.bytes);

//       setState(() {});
//       await _ocrFromBytes(imageBytes!);
//       await page.close();
//       await doc.close();
//     } catch (e) {
//       print('PDF 처리 에러: $e');
//       setState(() {
//         _ocrText = 'PDF를 처리하는데 실패했습니다.';
//       });
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   // 파일 쓰기
//   Future<void> writeToFile(ByteData data, String path) {
//     final buffer = data.buffer;
//     return File(path).writeAsBytes(
//         buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }

//   // 파일 선택기 실행
//   void runFilePiker() async {
//     _resetState();
//     // android && ios only
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // 이미지와 PDF 확장자 허용
//       allowMultiple: false,
//     );

//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.first;
//       if (file.bytes != null) {
//         // iOS에서는 bytes를 직접 사용
//         imageBytes = file.bytes!;

//         if (file.extension?.toLowerCase() == 'pdf') {
//           final tempDir = await getTemporaryDirectory();
//           final tempPath = '${tempDir.path}/temp.pdf';
//           await File(tempPath).writeAsBytes(file.bytes!);
//           await _ocrFromPdf(tempPath);
//         } else {
//           await _ocrFromBytes(file.bytes!);
//         }
//       } else if (file.path != null) {
//         // Android 경우 path 사용
//         if (file.path!.endsWith('.pdf')) {
//           await _ocrFromPdf(file.path!);
//         } else {
//           await _ocrFromFile(file.path!);
//         }
//       }
//     }
//   }

//   // 파일을 Uint8List로 변환하여 OCR 수행
//   Future<void> _ocrFromFile(String filePath) async {
//     // 새로운 메소드 추가
//     setState(() {
//       loading = true;
//     });
//     try {
//       imageBytes = await File(filePath).readAsBytes(); // 파일을 Uint8List로 읽기
//       setState(() {});
//       await _ocrFromBytes(imageBytes!); // Uint8List 전달
//     } catch (e) {
//       print('이미지 로딩 에러: $e'); // 에러 로깅
//       _ocrText = '이미지를 불러오는데 실패했습니다.';
//     } finally {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   // Uint8List를 사용하여 OCR 수행
//   Future<void> _ocrFromBytes(Uint8List bytes) async {
//     // 새로운 메소드 추가
//     if (selectList.isEmpty) {
//       print("Please select language");
//       return;
//     }

//     try {
//       var langs = selectList.join("+");
//       // 임시 파일 생성
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = '${tempDir.path}/temp_image.png';
//       final tempFile = File(tempPath);
//       await tempFile.writeAsBytes(bytes);
//       _ocrText = await FlutterTesseractOcr.extractText(tempPath,
//           language: langs,
//           args: {
//             "preserve_interword_spaces": "1",
//           });
//       // 줄바꿈 문자를 시각화하여 출력
//       Logger().d('OCR 원본 텍스트:\n${_ocrText.replaceAll('\n', '\\n')}');
//       parsedResult = parseOCRText(_ocrText);
//       await tempFile.delete();
//     } catch (e) {
//       print('OCR 에러: $e'); // 에러 로깅
//       _ocrText = '텍스트 추출에 실패했습니다.';
//     }
//     setState(() {});
//   }

//   // 상태 초기화
//   void _resetState() {
//     setState(() {
//       _ocrText = '';
//       imageBytes = null;
//       loading = false;
//     });
//   }

// // 사업자 등록번호 추출
//   String? _extractBusinessNumber(String text) {
//     final businessPattern = RegExp(r'\d{3}[-/.]\d{2}[-/.]\d{5}');
//     final match = businessPattern.firstMatch(text);
//     if (match != null) {
//       // 구분자(-, /, .)를 하이픈(-)으로 통일
//       Logger().d(
//           '추출된 사업자 등록번호: ${match.group(0)!.replaceAll(RegExp(r'[/.]'), '-')}');
//       return match.group(0)!.replaceAll(RegExp(r'[/.]'), '-');
//     }

//     return null;
//   }

//   // 개업연월일 추출
//   DateTime? _extractDate(String text) {
//     // "개 업 연 월 일 : 2019년 09 월 06 일" 패턴을 찾기 위한 정규식
//     final startDatePattern = RegExp(
//         r'개\s*업\s*연\s*월\s*일\s*:\s*(\d{4})\s*년\s*(\d{2})\s*월\s*(\d{2})\s*일');

//     final match = startDatePattern.firstMatch(text);
//     if (match != null) {
//       try {
//         final year = int.parse(match.group(1)!); // 첫 번째 그룹 (연도)
//         final month = int.parse(match.group(2)!); // 두 번째 그룹 (월)
//         final day = int.parse(match.group(3)!); // 세 번째 그룹 (일)

//         final date = DateTime(year, month, day);
//         Logger().d('파싱된 날짜: ${formatter.format(date)}');
//         return date;
//       } catch (e) {
//         Logger().e('날짜 파싱 에러: $e');
//       }
//     } else {
//       Logger().w('개업연월일을 찾을 수 없습니다.');
//     }

//     return null;
//   }

//   // 주소 추출 메소드 추가
//   String? _extractAddress(List<String> lines) {
//     // 다양한 패턴을 처리하는 정규식
//     final addressPattern =
//         RegExp(r'사\s*[업엄]\s*장\s*소\s*재\s*지\s*[：:]\s*(.*?)(?=\n)|'
//             r'사업장\s*소재지\s*(.*?)(?=\n)' // 두 번째 패턴
//             );

//     final fullText = lines.join('\n');

//     final match = addressPattern.firstMatch(fullText);
//     if (match != null) {
//       try {
//         // group(1) 또는 group(2) 중 null이 아닌 것을 선택
//         final address = (match.group(1) ?? match.group(2))?.trim();

//         // 주소 데이터 로깅
//         Logger().d('추출된 주소: $address');

//         return address;
//       } catch (e) {
//         Logger().e('주소 추출 에러: $e');
//       }
//     } else {
//       Logger().w('사업장 소재지를 찾을 수 없습니다.');
//     }

//     return null;
//   }

//   /////////////////////////////////// 사업자 정보 객체 추출 ///////////////////////////////////

//   // OCR 텍스트 파싱 메소드
//   ParsedOCRResult parseOCRText(String text) {
//     final lines =
//         text.split('\n').where((line) => line.trim().isNotEmpty).toList();

//     return ParsedOCRResult(
//       // 날짜 추출 (예: YYYY-MM-DD 형식)
//       startDate: _extractDate(text),

//       // 사업자 등록번호 추출
//       businessNumber: _extractBusinessNumber(text),

//       // 주요 텍스트 블록
//       address: _extractAddress(lines),

//       // businessName: _extractBusinessName(text),
//     );
//   }
// }

// // 파싱 결과를 저장할 모델 클래스
// class ParsedOCRResult {
//   final DateTime? startDate;
//   final String? businessNumber;
//   final String? address;
//   // final String? businessName;

//   ParsedOCRResult({
//     this.startDate,
//     this.businessNumber,
//     this.address,
//     // this.businessName,
//   });
// }
