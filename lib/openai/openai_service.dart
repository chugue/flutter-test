import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;

class OpenAIService {
  Future<String> extractTextFromImage(Uint8List imageBytes) async {
    final image = img.decodeImage(imageBytes);
    final resizedImage = img.copyResize(image!, width: 1000); // 너비를 800으로 조정
    final compressedImageBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 100)); // 품질을 70으로 설정

    final base64Image = base64Encode(compressedImageBytes);
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        // 'messages': [
        //   {
        //     'role': 'user',
        //     'content': [
        //       {
        //         'type': 'text',
        //         'text':
        //             '너는 뛰어난 세무사야. 이 이미지는 사업자 등록증이고, 여기서 사업자 등록번호, 개업연월일, 사업장 주소를 추출해서 json으로 반환해야해. 너가 채워야 할 필드는 bizNum, openDate, address, detail address에 매칭해서 한글로 반환해야해'
        //       },
        //       {
        //         'type': 'image_url',
        //         'image_url': {
        //           'url':
        //               'https://ims365.co.kr/file_data/ims365s/2020/09/23/584537f7305734571cbaf170666715cc.jpg'
        //         },
        //       }
        //     ]
        //   },
        // ],
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    '너는 뛰어난 세무사야. 이 이미지는 사업자 등록증이고, 여기서 사업자 등록번호, 개업연월일, 사업장 주소를 추출해서 json으로만 반환해야해.\n너가 채워야 할 필드는 bizNum, openDate, baseAddress, detailAddress에 매칭해서 한글로 반환해야해.\n그리고 보통 주소는 기본주소와 상세주소로 나누어 지는데, 주소가 --서울특별시 종로구 종로 6, 5층 스타필드 빌리지(서린동, 광화문우체국)-- 이런식으로 되어있으면 \n기본주소는 --서울특별시 종로구 종로 6--이고 상세주소는 --5층 스타필드 빌리지(서린동, 광화문우체국)-- 이런식으로 나누어져야해 \n그리고 모든 주소는 한국에서 실존 지역명이어야 해'
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
      Logger().i('Full Response: ${jsonEncode(data)}');
      final totalTokens = data['usage']['total_tokens'];
      Logger().i('Total tokens: $totalTokens');
      Logger().i(data['choices'][0]['message']['content']);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to extract text: ${response.body}');
    }
  }
}
