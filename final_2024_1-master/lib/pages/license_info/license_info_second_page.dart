import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'license_info_last_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class LicenseInfoSecondPage extends StatefulWidget {
  final int userId; // 사용자 ID
  final String licenseName; // 자격증/면허명
  final String userName; // 사용자 이름

  const LicenseInfoSecondPage({
    super.key,
    required this.userId,
    required this.licenseName,
    required this.userName
  });

  @override
  _LicenseInfoSecondPageState createState() => _LicenseInfoSecondPageState();
}

class _LicenseInfoSecondPageState extends State<LicenseInfoSecondPage> {
  DateTime? _selectedDate; // 선택된 날짜
  bool _isDateEmpty = false; // 날짜 입력 여부 확인 변수
  bool _isFutureDate = false; // 미래 날짜 여부 확인 변수

  // 날짜 선택기를 표시하는 함수
  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3, // 날짜 선택기 높이 설정
          decoration: BoxDecoration(
            color: Colors.white, // 배경색
            border: Border.all(color: Color(0xFF001ED6), width: 2.0), // 테두리 색상 및 두께
            borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기
          ),
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date, // 날짜 모드
            initialDateTime: DateTime.now(), // 초기 날짜 설정
            maximumDate: DateTime.now(), // 선택할 수 있는 최대 날짜를 오늘로 설정
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDate = newDateTime; // 새로 선택된 날짜 저장
                _isFutureDate = newDateTime.isAfter(DateTime.now()); // 미래 날짜 여부 확인
              });
            },
          ),
        );
      },
    ).whenComplete(() {
      // 날짜 선택기가 닫힌 후 실행되는 코드
      setState(() {
        _selectedDate ??= DateTime.now(); // 날짜가 선택되지 않았으면 현재 날짜로 설정
        _isFutureDate = _selectedDate!.isAfter(DateTime.now()); // 미래 날짜 여부 확인
      });
    });
  }

  // '다음' 버튼이 눌렸을 때 실행되는 함수
  void _onNextButtonPressed() {
    setState(() {
      _isDateEmpty = _selectedDate == null; // 날짜 입력 여부 확인
      _isFutureDate = _selectedDate != null && _selectedDate!.isAfter(DateTime.now()); // 미래 날짜 여부 확인
    });

    if (_isDateEmpty || _isFutureDate) {
      // 날짜가 선택되지 않았거나 미래 날짜인 경우 함수 종료
      return;
    }

    // 날짜 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '취득일 확인', // 확인 페이지 제목
          infoLabel: '취득일이', // 정보 레이블
          info: '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일', // 선택된 날짜
          onConfirmed: () {
            // 확인 버튼이 눌렸을 때 실행되는 코드
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LicenseInfoLastPage(
                  userId: widget.userId, // 사용자 ID
                  licenseName: widget.licenseName, // 자격증/면허명
                  date: '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일', // 선택된 날짜
                  userName: widget.userName, // 사용자 이름
                ),
              ),
            );
          },
        ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님은\n해당 자격증/면허를\n언제\n취득하셨나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isDateEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '취득일을 정확히 선택해주세요.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_isFutureDate)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '미래 날짜는 선택할 수 없습니다.',
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
                      onPressed: () => _showDatePicker(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedDate == null
                            ? '취득일 선택'
                            : '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
                        style: TextStyle(
                          color: Color(0xFF001ED6),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 130),
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
