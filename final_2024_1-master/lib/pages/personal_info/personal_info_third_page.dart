import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_fourth_page.dart';

class ThirdPage extends StatefulWidget {
  final String name;
  final String birth;

  const ThirdPage({super.key, required this.name, required this.birth});

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final List<TextEditingController> _controllers = List.generate(13, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(13, (index) => FocusNode());
  bool _isSSNEmpty = false; // 주민등록번호가 비어 있는지 여부를 확인하는 변수

  void _onNextButtonPressed() {
    // 다음 버튼을 눌렀을 때 실행되는 함수
    setState(() {
      _isSSNEmpty = _controllers.any((controller) => controller.text.isEmpty);
    });

    if (_isSSNEmpty) {
      return;
    }

    String fullSSN = _controllers.sublist(0, 6).map((controller) => controller.text).join() + '-' +
        _controllers.sublist(6).map((controller) => controller.text).join();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '주민등록번호 확인',
          infoLabel: '주민등록번호가',
          info: fullSSN,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FourthPage(
                  name: widget.name,
                  birth: widget.birth,
                  ssn: fullSSN,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSSNField(TextEditingController controller, FocusNode focusNode, {bool autoFocus = false}) {
    return Container(
      width: 30,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF001ED6), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        autofocus: autoFocus,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 30,
          color: Color(0xFF001ED6),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
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
        resizeToAvoidBottomInset: true, // Avoid resizing the screen when the keyboard appears
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 150), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님의\n주민등록번호를\n입력해주세요.',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                      height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isSSNEmpty)
                    Text(
                      '주민등록번호를 다시 입력해주세요!!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) => _buildSSNField(_controllers[index], _focusNodes[index], autoFocus: index == 0)),
                      ),
                      Text('-', style: TextStyle(fontSize: 30, color: Color(0xFF001ED6))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(7, (index) => _buildSSNField(_controllers[index + 6], _focusNodes[index + 6])),
                      ),
                    ],
                  ),
                  SizedBox(height: 90),
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
