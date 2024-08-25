import 'package:flutter/material.dart';
import 'academic_info_third_page.dart';
import 'academic_info_result_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class AcademicInfoSecondPage extends StatefulWidget {
    // 두 번째 학력 정보 입력 페이지를 위한 StatefulWidget 클래스
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
  bool _isSchoolNameEmpty = false;
  bool _hasInputSchoolName = false;

  @override
  void initState() {
  // 페이지가 초기화될 때 호출되는 메서드
    super.initState();
    _schoolNameController.addListener(_updateSchoolNameTextColor);
  }

  @override
  void dispose() {
  // 페이지가 소멸될 때 호출되는 메서드
    _schoolNameController.removeListener(_updateSchoolNameTextColor);
    _schoolNameController.dispose();
    super.dispose();
  }

  void _updateSchoolNameTextColor() {
  // 학교 이름 입력 상태에 따라 텍스트 색상 업데이트
    setState(() {
      _hasInputSchoolName = _schoolNameController.text.isNotEmpty;
    });
  }

  void _onNextButtonPressed() {
    setState(() {
      _isSchoolNameEmpty = _schoolNameController.text.isEmpty;
    });

    if (_isSchoolNameEmpty) {
    // 학교 이름이 비어있으면 리턴
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
                    userName: widget.userName,
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
  // 서버로 데이터를 전송하는 메서드
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
              userName: widget.userName,
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
  // UI를 구성하는 메서드
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
         // 스크롤이 가능한 화면 구성
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님이\n졸업하신 학교명을\n입력해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10),
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
                    width: 347,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Color(0xFF001ED6),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _schoolNameController,// 학교 이름을 입력받는 컨트롤러
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: _hasInputSchoolName ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '학교 이름',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,// 입력 필드의 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 180),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6),
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                      minimumSize: Size(345, 60),
                      shadowColor: Colors.black,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _onNextButtonPressed,
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
