import 'package:flutter/material.dart';
import 'academic_info_last_page.dart';

class AcademicInfoThirdPage extends StatefulWidget {
  final int userId;
  final String highestEdu;
  final String schoolName;
  final String userName;

  const AcademicInfoThirdPage({
    super.key,
    required this.userId,
    required this.highestEdu,
    required this.schoolName,
    required this.userName,
  });

  @override
  _AcademicInfoThirdPageState createState() => _AcademicInfoThirdPageState();
}

class _AcademicInfoThirdPageState extends State<AcademicInfoThirdPage> {
  String? _selectedMajorCategory;
  bool _isMajorCategoryEmpty = false; // 전공 계열이 비어 있는지 여부를 확인하는 변수

  final List<String> _majorCategories = [
    '인문계열',
    '사회계열',
    '교육계열',
    '공학계열',
    '자연계열',
    '의약계열',
    '예체능계열',
  ];

  void _onNextButtonPressed() {
    setState(() {
      _isMajorCategoryEmpty = _selectedMajorCategory == null;
    });

    if (!_isMajorCategoryEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcademicInfoLastPage(
            userId: widget.userId,
            highestEdu: widget.highestEdu,
            schoolName: widget.schoolName,
            major: _selectedMajorCategory!,
            userName: widget.userName, // 사용자 이름을 전달
          ),
        ),
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
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님의\n전공 계열을\n선택해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apple SD Gothic Neo',
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isMajorCategoryEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        '전공 계열을 다시 선택해주세요.',
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedMajorCategory,
                          hint: Text(
                            '전공 계열을 선택하세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF001ED6),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMajorCategory = newValue;
                              _isMajorCategoryEmpty = false; // 선택하면 오류 메시지 숨김
                            });
                          },
                          items: _majorCategories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF001ED6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor: Colors.white, // 드롭다운 배경색
                          iconEnabledColor: Color(0xFF001ED6), // 드롭다운 아이콘 색상
                          underline: SizedBox.shrink(), // 기본 밑줄 제거
                          alignment: Alignment.centerLeft, // 드롭다운 내용 정렬
                          borderRadius: BorderRadius.circular(24.0),
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
