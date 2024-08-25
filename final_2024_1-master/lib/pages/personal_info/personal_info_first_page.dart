import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_second_page.dart';

// FirstPage: 사용자가 이름을 입력하는 페이지
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
    _nameController.addListener(_updateTextColor); // 입력 상태에 따른 텍스트 색상 업데이트 리스너 추가
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateTextColor);
    _nameController.dispose();
    super.dispose();
  }

  // 텍스트 입력 상태에 따라 UI 업데이트
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

    String fullName = _nameController.text + ' 선생님'; // 입력된 이름에 '선생님' 추가

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
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // 입력 창의 내부 패딩
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '성함',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6),
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60),
                      shadowColor: Colors.black,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _onNextButtonPressed, // 다음 버튼을 눌렀을 때 함수 실행
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
