import 'package:flutter/material.dart';
import 'academic_info_result_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class AcademicInfoLastPage extends StatefulWidget {
  final int userId;
  final String highestEdu;
  final String schoolName;
  final String major;
  final String userName; // 사용자 이름 추가

  const AcademicInfoLastPage({
    super.key,
    required this.userId,
    required this.highestEdu,
    required this.schoolName,
    required this.major,
    required this.userName, // 사용자 이름 추가
  });

  @override
  _AcademicInfoLastPageState createState() => _AcademicInfoLastPageState();
}

class _AcademicInfoLastPageState extends State<AcademicInfoLastPage> {
  final TextEditingController _detailedMajorController = TextEditingController();
  bool _isDetailedMajorEmpty = false; // 세부 전공이 비어 있는지 여부를 확인하는 변수

  void _onNextButtonPressed() {
    setState(() {
      _isDetailedMajorEmpty = _detailedMajorController.text.isEmpty;
    });

    if (_isDetailedMajorEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '세부 전공 확인',
          infoLabel: '세부 전공이',
          info: _detailedMajorController.text,
          onConfirmed: () {
            _sendData();
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
          'schoolName': widget.schoolName,
          'major': widget.major,
          'detailedMajor': _detailedMajorController.text,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcademicInfoResultPage(
              userId: widget.userId,
              highestEdu: widget.highestEdu,
              schoolName: widget.schoolName,
              major: widget.major,
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
                  SizedBox(height: 200),
                  Text(
                    '${widget.userName}님의\n세부 전공을\n입력해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apple SD Gothic Neo',
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isDetailedMajorEmpty)
                    Text(
                      '세부 전공을 정확히 입력해주세요.',
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
                        controller: _detailedMajorController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF001ED6),
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '세부 전공',
                          hintStyle: TextStyle(
                            color: Color(0xFF001ED6),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
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


