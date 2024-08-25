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
  late TextEditingController _introductionController;// 텍스트 필드의 컨트롤러
  late ScrollController _scrollController; // 추가

  @override
  void initState() {
    super.initState();
    // 초기 자기소개서 텍스트로 텍스트 컨트롤러 초기화
    _introductionController = TextEditingController(text: widget.initialText);
    _scrollController = ScrollController(); // 추가
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _scrollController.dispose(); // 추가
    super.dispose();
  }

// 서버에 자기소개서 저장하는 비동기 함수
  Future<void> _saveIntroduction() async {
    try {
    // HTTP POST 요청을 사용하여 서버에 데이터를 보냄
      var response = await http.post(
        Uri.parse('$BASE_URL/introduction-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'gpt': _introductionController.text}),
      );

// 요청이 성공적으로 완료되면 이전 페이지로 돌아가면서 텍스트를 반환
      if (response.statusCode == 200) {
        await Future.delayed(Duration(milliseconds: 300));
        Navigator.pop(context, _introductionController.text);
      } else {
      // 오류 발생 시 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
    // 예외 발생 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController, // 추가
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Text(
                    '자기소개서를\n수정해주세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 가로 사이즈를 줄임
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Color(0xFF001ED6),
                        width: 2.0,
                      ),
                    ),
                    child: Scrollbar(
                      controller: _scrollController, // 추가
                      thumbVisibility: true, // 스크롤바 항상 표시
                      child: TextField(
                        controller: _introductionController,
                        maxLines: 15,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 18, // 글씨 크기
                          fontWeight: FontWeight.bold, // 글씨 굵기
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6),
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,),
                      minimumSize: Size(345, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 5, // 버튼의 그림자 높이
                    ),
                    onPressed: _saveIntroduction,
                    child: const Text(
                      '수정 완료',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
