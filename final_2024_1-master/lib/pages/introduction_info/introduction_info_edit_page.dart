import 'package:final_2024_1/config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';


class IntroductionInfoEditPage extends StatefulWidget {
  final int userId;
  final String initialText;

  const IntroductionInfoEditPage({super.key, required this.userId, required this.initialText});

  @override
  _IntroductionInfoEditPageState createState() => _IntroductionInfoEditPageState();
}

class _IntroductionInfoEditPageState extends State<IntroductionInfoEditPage> {
  late TextEditingController _introductionController;

  @override
  void initState() {
    super.initState();
    _introductionController = TextEditingController(text: widget.initialText);
  }

  Future<void> _saveIntroduction() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/introduction-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'gpt': _introductionController.text}),
      );

      if (response.statusCode == 200) {
        // 화면 전환 전에 약간의 딜레이를 추가
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context, _introductionController.text); // 수정된 텍스트를 반환
      } else {
        print('데이터 업데이트 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자기소개서 수정"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _introductionController,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '자기소개서 내용을 수정하세요',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIntroduction,
              child: const Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }
}


