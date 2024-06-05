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
  bool _isSchoolNameEmpty = false;
  bool _hasInputSchoolName = false;

  @override
  void initState() {
    super.initState();
    _schoolNameController.addListener(_updateSchoolNameTextColor);
  }

  @override
  void dispose() {
    _schoolNameController.removeListener(_updateSchoolNameTextColor);
    _schoolNameController.dispose();
    super.dispose();
  }

  void _updateSchoolNameTextColor() {
    setState(() {
      _hasInputSchoolName = _schoolNameController.text.isNotEmpty;
    });
  }

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
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님이\n졸업하신 학교명을\n입력해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apple SD Gothic Neo',
                      height: 1.2,
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
                        controller: _schoolNameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: _hasInputSchoolName ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '학교 이름',
                          hintStyle: TextStyle(
                            color: Colors.grey,
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
