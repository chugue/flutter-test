import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:test/openai/openai_service.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  String _ocrText = '';
  Uint8List? imageBytes;
  bool loading = false;
  final OpenAIService openAIService = OpenAIService(); // API 키 입력

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      imageBytes == null
                          ? Container()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.memory(imageBytes!)),
                      loading
                          ? const Column(
                              children: [CircularProgressIndicator()])
                          : Text(_ocrText),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          runFilePicker();
        },
        tooltip: 'OCR',
        child: const Icon(Icons.add),
      ),
    );
  }

  // 파일 선택기 실행
  void runFilePicker() async {
    _resetState();
    // android && ios only
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // 이미지와 PDF 확장자 허용
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.bytes != null) {
        // iOS에서는 bytes를 직접 사용
        setState(() {
          imageBytes = file.bytes!;
        });

        if (file.extension?.toLowerCase() == 'pdf') {
          final tempDir = await getTemporaryDirectory();
          final tempPath = '${tempDir.path}/temp.pdf';
          await File(tempPath).writeAsBytes(file.bytes!);
          await _ocrFromPdf(tempPath);
        } else {
          await _ocrFromBytes(file.bytes!);
        }
      } else if (file.path != null) {
        // Android 경우 path 사용
        if (file.path!.endsWith('.pdf')) {
          await _ocrFromPdf(file.path!);
        } else {
          await _ocrFromFile(file.path!);
        }
      }
    }
  }

  // PDF 파일을 이미지로 변환하고 OCR 수행
  Future<void> _ocrFromPdf(String pdfPath) async {
    setState(() {
      loading = true;
    });
    try {
      final doc = await PdfDocument.openFile(pdfPath);
      final page = await doc.getPage(1); // 첫 페이지 가져오기

      // 페이지를 이미지로 렌더링
      final pdfImageBytes = await page
          .render(
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.jpeg,
            backgroundColor: '#FFFFFF',
          )
          .then((value) => value?.bytes);

      if (pdfImageBytes != null) {
        setState(() {
          imageBytes = pdfImageBytes;
        });
        await _extractTextFromImage(pdfImageBytes);
      }

      await page.close();
      await doc.close();
    } catch (e) {
      Logger().e('PDF 처리 에러: $e');
      _ocrText = 'PDF를 처리하는데 실패했습니다.';
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // OpenAI API를 통해 이미지에서 텍스트 추출
  Future<void> _extractTextFromImage(Uint8List bytes) async {
    setState(() {
      loading = true;
    });
    try {
      _ocrText = await openAIService.extractTextFromImage(bytes);
    } catch (e) {
      Logger().e('OCR 에러: $e');
      _ocrText = '텍스트 추출에 실패했습니다.';
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // 파일을 Uint8List로 변환하여 OCR 수행
  Future<void> _ocrFromFile(String filePath) async {
    // 새로운 메소드 추가
    setState(() {
      loading = true;
    });
    try {
      imageBytes = await File(filePath).readAsBytes(); // 파일을 Uint8List로 읽기
      setState(() {});
      await _extractTextFromImage(imageBytes!); // Uint8List 전달
    } catch (e) {
      print('이미지 로딩 에러: $e'); // 에러 로깅
      _ocrText = '이미지를 불러오는데 실패했습니다.';
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Uint8List를 사용하여 OCR 수행
  Future<void> _ocrFromBytes(Uint8List bytes) async {
    try {
      // 임시 파일 생성
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_image.png';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(bytes);
      await _extractTextFromImage(bytes);

      await tempFile.delete();
    } catch (e) {
      print('OCR 에러: $e'); // 에러 로깅
      _ocrText = '텍스트 추출에 실패했습니다.';
    }
    setState(() {});
  }

  // 상태 초기화
  void _resetState() {
    setState(() {
      _ocrText = '';
      imageBytes = null;
      loading = false;
    });
  }
}
