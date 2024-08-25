import 'package:flutter/material.dart';
import 'academic_info_fourth_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';


class AcademicInfoThirdPage extends StatefulWidget {
  // 세 번째 학력 정보 입력 페이지를 위한 StatefulWidget 클래스
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
  String? _selectedMajorCategory;// 선택된 전공 계열
  bool _isMajorCategoryEmpty = false; // 전공 계열이 선택되지 않았는지 여부

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
  // '다음' 버튼이 눌렸을 때 호출되는 메서드
    setState(() {
      _isMajorCategoryEmpty = _selectedMajorCategory == null;
    });

    if (!_isMajorCategoryEmpty) {
    // 전공 계열이 선택되었다면
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonalInfoConfirmationPage(
            // 전공 계열 확인 페이지로 이동
            title: '전공 계열 확인',
            infoLabel: '전공 계열이',
            info: _selectedMajorCategory!, // 선택된 전공 계열 전달
            onConfirmed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcademicInfoFourthPage(
                    // 네 번째 학력 정보 입력 페이지로 이동
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
  // UI를 구성하는 메서드
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 터치하면 키보드 숨기기
      },
      child: Scaffold(
        body: SingleChildScrollView(
        // 스크롤이 가능한 화면 구성
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
              // 위젯들을 세로로 배치
                children: [
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님의\n전공 계열을\n선택해주세요', // 사용자 이름을 포함한 안내 문구
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
                        '전공 계열을 다시 선택해주세요.',// 전공 계열이 선택되지 않았을 때 경고 메시지
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                  // 전공 계열 선택 드롭다운
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
                          value: _selectedMajorCategory, // 선택된 전공 계열 값
                          hint: Center(
                            child: Text(
                              '전공 계열 선택', // 힌트 텍스트
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
                              _selectedMajorCategory = newValue; // 전공 계열 선택 시 상태 업데이트
                              _isMajorCategoryEmpty = false;// 전공 계열 선택이 완료되었으므로 플래그 해제
                            });
                          },
                          items: _majorCategories.map<DropdownMenuItem<String>>((String value) {
                            // 전공 계열 리스트를 드롭다운 아이템으로 변환
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
                          }).toList(), // 리스트를 드롭다운 아이템으로 변환하여 반환
                          dropdownColor: Colors.white, // 드롭다운 배경 색상
                          iconEnabledColor: Color(0xFF001ED6), // 드롭다운 아이콘 색상
                          underline: SizedBox.shrink(), // 드롭다운의 기본 언더라인 제거
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
                    onPressed: _onNextButtonPressed, // 버튼이 눌렸을 때 호출될 메서드
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
