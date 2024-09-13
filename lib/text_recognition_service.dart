import 'dart:io';
import 'package:dio/dio.dart';
import 'package:food_coarch/NutritionInfo.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TextRecognitionService {
  final Dio _dio = Dio();

  Future<NutritionInfo> recognizeText(File imageFile) async {
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path),
    });

    final response = await _dio.post('${dotenv.get("API_URL")}/upload', data: formData);
    if (response.statusCode == 200) {
      // 서버 응답이 성공적인 경우, JSON 데이터를 파싱하여 NutritionInfo 객체를 생성합니다.
      return NutritionInfo.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load nutrition info');
    }
  }

  Future<void> createNutrition(NutritionInfo info) async {
    print(info.toJson());
    final response = await _dio.post('${dotenv.get("API_URL")}/create', data: info.toJson());
  }
}