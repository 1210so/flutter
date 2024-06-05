import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'license_info_last_page.dart';
import '../academic_info/academic_info_confirmation_page.dart';

class LicenseInfoSecondPage extends StatefulWidget {
  final int userId;
  final String licenseName;
  final String userName;

  const LicenseInfoSecondPage({super.key, required this.userId, required this.licenseName, required this.userName});

  @override
  _LicenseInfoSecondPageState createState() => _LicenseInfoSecondPageState();
}

class _LicenseInfoSecondPageState extends State<LicenseInfoSecondPage> {
  DateTime? _selectedDate;
  bool _isDateEmpty = false;
  bool _isFutureDate = false; // 미래 날짜 여부 확인 변수

  void _showDatePicker(BuildContext context) {
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
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDate = newDateTime;
                _isFutureDate = newDateTime.isAfter(DateTime.now());
              });
            },
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _selectedDate ??= DateTime.now();
        _isFutureDate = _selectedDate!.isAfter(DateTime.now());
      });
    });
  }

  void _onNextButtonPressed() {
    setState(() {
      _isDateEmpty = _selectedDate == null;
      _isFutureDate = _selectedDate != null && _selectedDate!.isAfter(DateTime.now());
    });

    if (_isDateEmpty || _isFutureDate) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademicInfoConfirmationPage(
          title: '취득일 확인',
          infoLabel: '취득일이',
          info: '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LicenseInfoLastPage(
                  userId: widget.userId,
                  licenseName: widget.licenseName,
                  date: '${_selectedDate!.year}년 ${_selectedDate!.month}월 ${_selectedDate!.day}일',
                  userName: widget.userName,
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
                      fontFamily: 'Apple SD Gothic Neo',
                      height: 1.2,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
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
