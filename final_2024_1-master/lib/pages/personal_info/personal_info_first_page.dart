import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_second_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _nameController = TextEditingController(); // 이름 입력 컨트롤러
  bool _isNameEmpty = false; // 이름이 비어 있는지 여부를 확인하는 변수
  bool _hasInput = false; // 이름이 입력되었는지 여부를 확인하는 변수

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateTextColor);
    _nameController.dispose();
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {
      _hasInput = _nameController.text.isNotEmpty;
    });
  }

  void _onNextButtonPressed() {
    // 다음 버튼을 눌렀을 때 실행되는 함수
    setState(() {
      _isNameEmpty = _nameController.text.isEmpty;
    });

    if (_isNameEmpty) {
      return;
    }

    String fullName = _nameController.text + ' 선생님';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '이름 확인', // 확인 페이지의 제목
          infoLabel: '성함이', // 확인 페이지의 정보 라벨
          info: fullName, // 확인 페이지에 전달될 이름 정보
          onConfirmed: () {
            // 확인 버튼을 눌렀을 때 실행되는 코드
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondPage(name: _nameController.text),
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
                  SizedBox(height: 250), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '성함이\n어떻게 되시나요?',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  if (_isNameEmpty)
                    Text(
                      '성함을 정확히 입력해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                    width: 347, // 입력 창의 너비
                    height: 60, // 입력 창의 높이
                    decoration: BoxDecoration(
                      color: Colors.white, // 입력 창의 배경색
                      borderRadius: BorderRadius.circular(24.0), // 입력 창의 모서리 둥글기
                      border: Border.all(
                        color: Color(0xFF001ED6), // 입력 창의 테두리 색상
                        width: 2.0, // 입력 창의 테두리 두께
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 입력 창의 내부 패딩
                      child: TextField(
                        controller: _nameController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, // 입력 텍스트의 크기
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '성함', // 입력 필드의 힌트 텍스트
                          hintStyle: TextStyle(
                            color: Colors.grey, // 힌트 텍스트의 색상
                            fontSize: 28, // 힌트 텍스트의 크기
                            fontWeight: FontWeight.bold, // 힌트 텍스트의 굵기
                          ),
                          border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 6, // 버튼의 그림자 높이,
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
}
