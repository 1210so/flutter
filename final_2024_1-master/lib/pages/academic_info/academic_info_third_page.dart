import 'package:flutter/material.dart';
import 'academic_info_fourth_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';


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
  bool _isMajorCategoryEmpty = false;

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
          builder: (context) => PersonalInfoConfirmationPage(
            title: '전공 계열 확인',
            infoLabel: '전공 계열이',
            info: _selectedMajorCategory!,
            onConfirmed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcademicInfoFourthPage(
                    userId: widget.userId,
                    highestEdu: widget.highestEdu,
                    schoolName: widget.schoolName,
                    major: _selectedMajorCategory!,
                    userName: widget.userName,
                  ),
                ),
              );
            },
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
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
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
                          hint: Center(
                            child: Text(
                              '전공 계열 선택',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF001ED6),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedMajorCategory = newValue;
                              _isMajorCategoryEmpty = false;
                            });
                          },
                          items: _majorCategories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF001ED6),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          dropdownColor: Colors.white,
                          iconEnabledColor: Color(0xFF001ED6),
                          underline: SizedBox.shrink(),
                          isExpanded: true, // 이 속성을 추가하여 드롭다운이 가로로 확장되도록 함
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
