import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

class NiceWebView extends StatefulWidget {
  const NiceWebView({super.key});

  @override
  State<NiceWebView> createState() => _NiceWebViewState();
}

class _NiceWebViewState extends State<NiceWebView> {
  late InAppWebViewController webViewController;
  String? htmlContent;

  @override
  void initState() {
    super.initState();
    _loadHtmlContent();
  }

  @override
  Widget build(BuildContext context) {
    if (htmlContent == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('NICE 본인인증'),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: htmlContent!,
          mimeType: 'text/html',
          encoding: 'utf-8',
        ),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          useHybridComposition: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          await Future.delayed(const Duration(milliseconds: 400));
          await controller.evaluateJavascript(source: "fnPopup();");
        },
      ),
    );
  }

  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////
  //////////////////////////////////// 내부 기능 메소드 ////////////////////////////////////

  // nice 인증 페이지 로드
  Future<void> _loadHtmlContent() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'http://127.0.0.1:3000/nice/html',
      );

      Logger().d(response.data);
      if (response.statusCode == 200 && response.data['success']) {
        setState(() {
          htmlContent = response.data['data'] as String?;
        });
      } else {
        print('인증 실패: ${response.statusCode}, ${response.data['message']}');
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}
