import 'package:flutter/material.dart';
import 'package:test/webview_screen.dart';

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WebViewScreen()),
            );
          },
          child: const Text('나이스 인증 테스트'),
        ),
      ),
    );
  }
}
