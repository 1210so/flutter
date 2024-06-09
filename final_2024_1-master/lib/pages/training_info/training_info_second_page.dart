import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'training_info_last_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class TrainingInfoSecondPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String trainingName;

  const TrainingInfoSecondPage({super.key, required this.userId, required this.userName, required this.trainingName});

  @override
  _TrainingInfoSecondPageState createState() => _TrainingInfoSecondPageState();
}

class _TrainingInfoSecondPageState extends State<TrainingInfoSecondPage> {
  int? _selectedStartYear;
  int? _selectedStartMonth;
  int? _selectedEndYear;
  int? _selectedEndMonth;
  bool _isStartDateEmpty = false;
  bool _isEndDateEmpty = false;
  bool _isPeriodInvalid = false;

  void _showYearMonthPicker(BuildContext context, bool isStartDate) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        int initialYearIndex = isStartDate
            ? (_selectedStartYear ?? 1950) - 1950
            : (_selectedEndYear ?? 1950) - 1950;
        int initialMonthIndex = isStartDate
            ? (_selectedStartMonth ?? 1) - 1
            : (_selectedEndMonth ?? 1) - 1;
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            color: Colors.white, // 배경색 설정
            border: Border.all(color: Color(0xFF001ED6), width: 2.0), // 테두리 파란색 설정
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialYearIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      if (isStartDate) {
                        _selectedStartYear = 1950 + index;
                      } else {
                        _selectedEndYear = 1950 + index;
                      }
                    });
                  },
                  children: List<Widget>.generate(76, (int index) {
                    return Center(child: Text('${1950 + index}년'));
                  }),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialMonthIndex),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      if (isStartDate) {
                        _selectedStartMonth = index + 1;
                      } else {
                        _selectedEndMonth = index + 1;
                      }
                    });
                  },
                  children: List<Widget>.generate(12, (int index) {
                    return Center(child: Text('${index + 1}월'));
                  }),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        if (isStartDate) {
          _selectedStartYear ??= 1950;
          _selectedStartMonth ??= 1;
        } else {
          _selectedEndYear ??= 1950;
          _selectedEndMonth ??= 1;
        }
      });
    });
  }

  bool _isValidPeriod() {
    if (_selectedStartYear == null || _selectedStartMonth == null || _selectedEndYear == null || _selectedEndMonth == null) {
      return false;
    }

    if (_selectedStartYear! > _selectedEndYear!) {
      return false;
    }

    if (_selectedStartYear! == _selectedEndYear! && _selectedStartMonth! > _selectedEndMonth!) {
      return false;
    }

    return true;
  }

  void _onNextButtonPressed() {
    setState(() {
      _isStartDateEmpty = _selectedStartYear == null || _selectedStartMonth == null;
      _isEndDateEmpty = _selectedEndYear == null || _selectedEndMonth == null;
      _isPeriodInvalid = !_isValidPeriod();
    });

    if (_isStartDateEmpty || _isEndDateEmpty || _isPeriodInvalid) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '훈련/교육 기간 확인',
          infoLabel: '훈련/교육 기간이',
          info: '${_selectedStartYear}년 ${_selectedStartMonth}월 ~ ${_selectedEndYear}년 ${_selectedEndMonth}월',
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainingInfoLastPage(
                  userId: widget.userId,
                  trainingName: widget.trainingName,
                  date: '${_selectedStartYear}년 ${_selectedStartMonth}월 ~ ${_selectedEndYear}년 ${_selectedEndMonth}월',
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
                children: [
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님,\n해당 훈련/교육을\n언제 받으셨나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isStartDateEmpty || _isEndDateEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '훈련/교육 기간을 정확히 입력해주세요.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_isPeriodInvalid)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '시작 날짜가 종료 날짜보다 앞서야 합니다.',
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
                      onPressed: () => _showYearMonthPicker(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedStartYear == null
                            ? '시작 날짜 선택'
                            : '$_selectedStartYear년 $_selectedStartMonth월',
                        style: TextStyle(
                          color: Color(0xFF001ED6),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                      onPressed: () => _showYearMonthPicker(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedEndYear == null
                            ? '종료 날짜 선택'
                            : '$_selectedEndYear년 $_selectedEndMonth월',
                        style: TextStyle(
                          color: Color(0xFF001ED6),
                          fontSize: 32,
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
