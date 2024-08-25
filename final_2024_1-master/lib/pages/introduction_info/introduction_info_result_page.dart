import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/pages/resume/check_resume_result_page.dart';
import 'introduction_info_edit_page.dart';
import 'package:final_2024_1/config.dart';

// 자기소개서 결과 페이지의 StatefulWidget 정의
class IntroductionInfoResultPage extends StatefulWidget {
  final int userId;
  final String introductionText;

  const IntroductionInfoResultPage({super.key, required this.userId, required this.introductionText});

  @override
  _IntroductionInfoResultPageState createState() => _IntroductionInfoResultPageState();
}

// 페이지의 상태를 관리하는 State 클래스
class _IntroductionInfoResultPageState extends State<IntroductionInfoResultPage> {
  late String _introductionText;

  @override
  void initState() {
    super.initState();
    _introductionText = widget.introductionText; // 초기 자기소개서 텍스트 설정
  }

// 자기소개서를 업데이트하는 비동기 함수
  Future<void> _updateIntroduction(String newText) async {
    var url = Uri.parse('$BASE_URL/introduction-info/update/${widget.userId}');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'gpt': newText}); // 요청 본문 설정

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        setState(() {
          _introductionText = newText;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('자기소개서가 성공적으로 업데이트되었습니다.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.reasonPhrase}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

// 자기소개서를 편집하는 함수
  void _editIntroduction() async {
  // 자기소개서 편집 페이지로 이동하고 결과를 기다림
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroductionInfoEditPage(
          userId: widget.userId,
          initialText: _introductionText,
        ),
      ),
    );

 // 결과가 문자열일 경우 자기소개서 업데이트
    if (result != null && result is String) {
      _updateIntroduction(result);
    }
  }

// 이력서 확인 페이지로 이동하는 함수
  void _goToResumeCheck() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckResumeResultPage(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
                children: [
                  SizedBox(height: 80), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '완성된\n자기소개서',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 20), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    'AI는 실수를 할 수 있습니다.\n중요한 정보를 확인해주세요!',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 20, // 텍스트 크기
                      color: Colors.red,
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9, // 가로 사이즈를 줄임
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white, // 입력 창의 배경색
                      borderRadius: BorderRadius.circular(24.0), // 입력 창의 모서리 둥글기
                      border: Border.all(
                        color: Color(0xFF001ED6), // 입력 창의 테두리 색상
                        width: 2.0, // 입력 창의 테두리 두께
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _introductionText.trim(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFFFFF), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFF001ED6), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
                      ),
                    ),
                    onPressed: _editIntroduction, // 자기소개서 수정 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '자기소개서 수정',
                      style: TextStyle(
                        fontSize: 18, // 버튼 텍스트의 크기
                        fontWeight: FontWeight.bold, // 버튼 텍스트의 굵기
                        color: Color(0xFF001ED6), // 버튼 텍스트의 색상
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 6, // 버튼의 그림자 높이,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
                      ),
                    ),
                    onPressed: _goToResumeCheck, // 최종 이력서 정보 확인하기 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '최종 이력서 정보 확인하기',
                      style: TextStyle(
                        fontSize: 18, // 버튼 텍스트의 크기
                        fontWeight: FontWeight.bold, // 버튼 텍스트의 굵기
                        color: Colors.white, // 버튼 텍스트의 색상
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // 추가된 공간
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
