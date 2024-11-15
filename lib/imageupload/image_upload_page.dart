import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!)
                : const Text('이미지를 선택하세요'),
            ElevatedButton(
              onPressed: () async {
                try {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() {
                      _imageFile = File(image.path);
                    });
                  } else {
                    print('No image selected');
                  }
                } catch (e) {
                  print('Error: $e');
                }
              },
              child: const Text('앨범에서 사진 선택하기'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_imageFile != null) {
                  await uploadFile(_imageFile!);
                } else {
                  print('이미지를 선택하세요');
                }
              },
              child: const Text('업로드하기'),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
//////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////

// 파일 업로드
Future<void> uploadFile(File file) async {
  String presignedUrl = await getPresignedUrl();

  final request = http.Request('PUT', Uri.parse(presignedUrl))
    ..headers['Content-Type'] = 'application/octet-stream'
    ..bodyBytes = await file.readAsBytes();

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Upload error: $e');
  }
}

// 업로드 권한 url 받아오기
Future<String> getPresignedUrl() async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:3000/file-api/check'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "storeId": "aaa",
      "originalFileName": "test.png",
    }),
  );
  if (response.statusCode == 201) {
    final json = jsonDecode(response.body);
    return json['data'];
  } else {
    throw Exception('Failed to get presigned URL');
  }
}
