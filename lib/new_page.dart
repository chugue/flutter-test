import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;

class NewPage extends StatelessWidget {
  const NewPage({super.key});

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
            ElevatedButton(
              onPressed: () async {
                final PermissionState result =
                    await PhotoManager.requestPermissionExtend();
                if (result.isAuth) {
                  final List<AssetPathEntity> assetPaths =
                      await PhotoManager.getAssetPathList(
                    type: RequestType.image,
                  );

                  if (assetPaths.isNotEmpty) {
                    final AssetPathEntity assetPath = assetPaths.first;
                    final List<AssetEntity> assetList =
                        await assetPath.getAssetListPaged(
                      page: 0,
                      size: 1,
                    );

                    if (assetList.isNotEmpty) {
                      final AssetEntity asset = assetList.first;
                      final File? file = await asset.file;

                      if (file != null) {
                        try {
                          String presignedUrl =
                              await getPresignedUrl(asset.title!);
                          await uploadFile(presignedUrl, file);
                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    }
                  }
                } else {
                  print('Permission denied');
                }
              },
              child: const Text('앨범에서 사진 선택하기'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> uploadFile(String presignedUrl, File file) async {
  final request = http.Request('PUT', Uri.parse(presignedUrl))
    ..headers['Content-Type'] = 'application/octet-stream'
    ..bodyBytes = await file.readAsBytes();

  final response = await request.send();
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('File upload failed');
  }
}

Future<String> getPresignedUrl(String fileName) async {
  final response = await http.get(Uri.parse(
      '<https://your-nest-api-url/file-api/presigned-url/$fileName>'));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get presigned URL');
  }
}
