import 'package:flutter/material.dart';
import 'academic_info_third_page.dart';
import 'academic_info_result_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class AcademicInfoSecondPage extends StatefulWidget {
  final int userId;
  final String highestEdu;
  final String userName;

  const AcademicInfoSecondPage({
    super.key,
    required this.userId,
    required this.highestEdu,
    required this.userName,
  });

  @override
  _AcademicInfoSecondPageState createState() => _AcademicInfoSecondPageState();
}

class _AcademicInfoSecondPageState extends State<AcademicInfoSecondPage> {
  final TextEditingController _schoolNameController = TextEditingController();
  bool _isSchoolNameEmpty = false; // 학교명이 비어 있는지 여부를 확인하는 변수

  void _onNextButtonPressed() {
    setState(() {
      _isSchoolNameEmpty = _schoolNameController.text.isEmpty;
    });

    if (_isSchoolNameEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '학교명 확인',
          infoLabel: '학교명이',
          info: _schoolNameController.text,
          onConfirmed: () {
            if (widget.highestEdu == '대학원' || widget.highestEdu == '대학교') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcademicInfoThirdPage(
                    userId: widget.userId,
                    highestEdu: widget.highestEdu,
                    schoolName: _schoolNameController.text,
                    userName: widget.userName, // 사용자 이름을 전달
                  ),
                ),
              );
            } else {
              _sendData();
            }
          },
        ),
      ),
    );
  }

  Future<void> _sendData() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/academic-info/save/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': widget.userId.toString(),
          'highestEdu': widget.highestEdu,
          'schoolName': _schoolNameController.text,
          'major': '',
          'detailedMajor': '',
        }),
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcademicInfoResultPage(
              userId: widget.userId,
              highestEdu: widget.highestEdu,
              schoolName: _schoolNameController.text,
              major: '',
              userName: widget.userName, // 사용자 이름을 전달
            ),
          ),
        );
      } else {
        print('데이터 저장 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
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
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 200), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.userName}님이\n졸업하신 학교명을\n입력해주세요.',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                      height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isSchoolNameEmpty)
                    Text(
                      '학교 이름을 정확히 입력해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                    width: 347, // 입력 창의 너비
                    height: 60, // 입력 창의 높이
                    decoration: BoxDecoration(
                      color: Colors.white, // 입력 창의 배경색
                      borderRadius: BorderRadius.circular(24.0), // 입력 창의 모서리 둥글기
                      border: Border.all(
                        color: Color(0xFF001ED6), // 입력 창의 테두리 색상
                        width: 2.0, // 입력 창의 테두리 두께
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 입력 창의 내부 패딩
                      child: TextField(
                        controller: _schoolNameController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20, // 입력 텍스트의 크기
                          color: Color(0xFF001ED6), // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '학교 이름', // 입력 필드의 힌트 텍스트
                          hintStyle: TextStyle(
                            color: Color(0xFF001ED6), // 힌트 텍스트의 색상
                            fontSize: 20, // 힌트 텍스트의 크기
                            fontWeight: FontWeight.bold, // 힌트 텍스트의 굵기
                          ),
                          border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 180),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 6, // 버튼의 그림자 높이
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
                      ),
                    ),
                    onPressed: _onNextButtonPressed, // 다음 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '다음',
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




