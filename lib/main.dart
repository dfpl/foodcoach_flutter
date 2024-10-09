import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'text_recognition_service.dart'; // TextRecognitionService 클래스를 정의한 파일을 임포트하세요.
import 'NutritionInfo.dart'; // NutritionInfo 모델을 정의한 파일을 임포트하세요.

void main() async {
  await dotenv.load(fileName: "assets/.env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextRecognitionWidget(),
    );
  }
}

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({super.key});

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  final ImagePicker _picker = ImagePicker();
  NutritionInfo? _nutritionInfo; // 서버로부터 받은 NutritionInfo 데이터를 저장할 변수

  Future<void> _pickAndRecognizeText() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final TextRecognitionService service = TextRecognitionService();
      final NutritionInfo recognizedInfo =
          await service.recognizeText(File(image.path));
      print(recognizedInfo.fileName);
      setState(() {
        _nutritionInfo = recognizedInfo;
      });
    }
  }

  void submitNutritionInfo() async {
    final TextRecognitionService service = TextRecognitionService();
    if (_nutritionInfo != null) {
      await service.createNutrition(_nutritionInfo!);
      setState(() {
        _nutritionInfo = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter OCR with Dio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickAndRecognizeText,
              child: const Text('이미지 가져오기'),
            ),
            _nutritionInfo != null
                ? Expanded(
                    child: ListView(
                    children: [
                      Image.network(
                        '${dotenv.get("API_URL")}/${_nutritionInfo?.fileName}', // 여기에 이미지 URL을 입력하세요.
                        width: 200, // 이미지의 너비를 지정 (옵션)
                        height: 200, // 이미지의 높이를 지정 (옵션)
                        fit: BoxFit.cover, // 이미지가 지정된 공간에 맞도록 조정 (옵션)
                      ),
                      ListTile(
                        title: const Text("제품이름"),
                        subtitle: TextField(
                          controller: TextEditingController(text: ''),
                          decoration: const InputDecoration(
                            hintText: "제품 이름을 입력해주세요",
                          ),
                          onChanged: (value) {
                            _nutritionInfo?.productName = value;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("용량"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.servingSize ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          onChanged: (value) {
                            _nutritionInfo?.servingSize = value;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("칼로리"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.calories ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          onChanged: (value) {
                            _nutritionInfo?.calories = value;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("나트륨"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.sodiumContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          onChanged: (value) {
                            _nutritionInfo?.sodiumContent = value;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("탄수화물"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.carbohydrateContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.carbohydrateContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("식이 섬유"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.fiberContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.fiberContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("당류"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.sugarContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.sugarContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("지방"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.fatContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.fatContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("트랜스지방"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.transFatContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.transFatContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("포화지방"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.saturatedFatContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.saturatedFatContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("콜레스테롤"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.cholesterolContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.cholesterolContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("단백질"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text: _nutritionInfo?.proteinContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.proteinContent = value;
                          // },
                        ),
                      ),
                      ListTile(
                        title: const Text("불포화지방"),
                        subtitle: TextField(
                          controller: TextEditingController(
                              text:
                                  _nutritionInfo?.unsaturatedFatContent ?? ''),
                          decoration: const InputDecoration(
                            hintText: "정보 없음",
                          ),
                          // onChanged: (value) {
                          //   _nutritionInfo?.unsaturatedFatContent = value;
                          // },
                        ),
                      ),
                    ],
                  ))
                : Container(child: const Text("No data")),
          ],
        ),
      ),
      floatingActionButton: _nutritionInfo != null
          ? FloatingActionButton(
              onPressed:
                  submitNutritionInfo, // 버튼을 누르면 submitNutritionInfo 함수 실행
              tooltip: 'Submit',
              child: const Icon(Icons.send),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 버튼을 하단 중앙에 배치
    );
  }
}
