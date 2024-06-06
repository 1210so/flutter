import 'package:flutter/material.dart';
import 'academic_info_second_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class AcademicInfoFirstPage extends StatefulWidget {
  final int userId;
  final String userName; // 추가된 사용자 이름 변수

  const AcademicInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _AcademicInfoFirstPageState createState() => _AcademicInfoFirstPageState();
}

class _AcademicInfoFirstPageState extends State<AcademicInfoFirstPage> {
  String? _highestEdu; // 학력 선택 변수
  bool _isEduEmpty = false; // 학력 선택 여부 확인 변수

  void _onNextButtonPressed() {
    setState(() {
      _isEduEmpty = _highestEdu == null;
    });

    if (_isEduEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '학력 확인',
          infoLabel: '최종 학력이',
          info: _highestEdu!,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademicInfoSecondPage(
                  userId: widget.userId,
                  highestEdu: _highestEdu!,
                  userName: widget.userName, // 사용자 이름을 전달
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
                  SizedBox(height: 150), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.userName}님의\n최종 학력을\n선택해주세요',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  if (_isEduEmpty)
                    Text(
                      '학력을 다시 선택해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildEducationButton('대학원'),
                      _buildEducationButton('대학교'),
                      _buildEducationButton('고등학교'),
                      _buildEducationButton('중학교'),
                      _buildEducationButton('초등학교'),
                      _buildEducationButton('그외'),
                    ],
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 5, // 버튼의 그림자 높이,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
                      ),
                    ),
                    onPressed: _onNextButtonPressed, // 다음 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18, // 버튼 텍스트의 크기
                        fontWeight: FontWeight.bold, // 버튼 텍스트의 굵기
                        color: Colors.white, // 버튼 텍스트의 색상
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // 추가된 공간
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationButton(String educationLevel) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _highestEdu = educationLevel;
        });
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: _highestEdu == educationLevel ? Colors.white : Color(0xFF001ED6),
        backgroundColor: _highestEdu == educationLevel ? Color(0xFF001ED6) : Colors.white, // 선택된 버튼의 텍스트 색상 변경
        side: BorderSide(color: _highestEdu == educationLevel ? Colors.white : Color(0xFF001ED6), width: 2), // 버튼의 테두리 색상
        minimumSize: Size(190, 70), // 버튼의 크기 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
        ),
        shadowColor: Colors.black, // 버튼의 그림자 색상
        elevation: 5, // 버튼의 그림자 높이,
      ),
      child: Text(
        educationLevel,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: _highestEdu == educationLevel ? Colors.white : Color(0xFF001ED6), // 선택된 버튼의 텍스트 색상 변경
        ),
      ),
    );
  }
}
