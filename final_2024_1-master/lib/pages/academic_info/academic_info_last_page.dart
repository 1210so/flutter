import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'academic_info_result_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_2024_1/config.dart';

// AcademicInfoLastPage는 사용자가 졸업 연도를 선택하고 입력한 정보를 서버에 전송하는 페이지
class AcademicInfoLastPage extends StatefulWidget {
  final int userId;
  final String highestEdu;
  final String schoolName;
  final String major;
  final String detailedMajor;
  final String userName;

  const AcademicInfoLastPage({
    super.key,
    required this.userId,
    required this.highestEdu,
    required this.schoolName,
    required this.major,
    required this.detailedMajor,
    required this.userName,
  });

  @override
  _AcademicInfoLastPageState createState() => _AcademicInfoLastPageState();
}
// 페이지의 상태를 관리하는 클래스
class _AcademicInfoLastPageState extends State<AcademicInfoLastPage> {
  int? _selectedYear;
  bool _isYearEmpty = false;
  bool _isFutureYear = false;

// 연도 선택을 위한 Picker를 표시하는 함수
  void _showYearPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF001ED6), width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              setState(() {
                _selectedYear = DateTime.now().year - index;
                _isFutureYear = _selectedYear! > DateTime.now().year;
              });
            },
            // 현재 연도부터 과거 100년까지의 연도를 표시
            children: List<Widget>.generate(100, (int index) {
              return Center(
                child: Text('${DateTime.now().year - index}'),
              );
            }),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _selectedYear ??= DateTime.now().year;
        _isFutureYear = _selectedYear! > DateTime.now().year;
      });
    });
  }

  void _onNextButtonPressed() {
    setState(() {
      _isYearEmpty = _selectedYear == null;
      _isFutureYear = _selectedYear != null && _selectedYear! > DateTime.now().year;
    });

    if (_isYearEmpty || _isFutureYear) {
      return;
    }
    // 졸업 연도 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '졸업 연도 확인',
          infoLabel: '졸업 연도가',
          info: '${_selectedYear!}년',
          onConfirmed: _sendData,
        ),
      ),
    );
  }
 // 사용자가 입력한 학력 정보를 서버로 전송하는 함수
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
          'detailedMajor': widget.detailedMajor,
          'graduationDate': '${_selectedYear!}년',
        }),
      );

      if (response.statusCode == 201) {
      // 데이터 저장에 성공하면 결과 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcademicInfoResultPage(
              userId: widget.userId,
              highestEdu: widget.highestEdu,
              schoolName: widget.schoolName,
              major: widget.major,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250),
                  Text(
                    '${widget.userName}님은\n언제 졸업하셨나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isYearEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '졸업 연도를 정확히 선택해주세요.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_isFutureYear)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '미래 연도는 선택할 수 없습니다.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                    child: ElevatedButton(
                      onPressed: () => _showYearPicker(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedYear == null
                            ? '졸업 연도 선택'
                            : '${_selectedYear!}년',
                        style: TextStyle(
                          color: Color(0xFF001ED6),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 200),
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


