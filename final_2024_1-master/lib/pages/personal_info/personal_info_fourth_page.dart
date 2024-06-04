import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_fifth_page.dart';

class FourthPage extends StatefulWidget {
  final String name;
  final String birth;
  final String ssn;

  const FourthPage({super.key, required this.name, required this.birth, required this.ssn});

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final List<TextEditingController> _controllers = List.generate(11, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(11, (index) => FocusNode());
  bool _isPhoneEmpty = false;

  void _onNextButtonPressed() {
    setState(() {
      _isPhoneEmpty = _controllers.any((controller) => controller.text.isEmpty);
    });

    if (_isPhoneEmpty) {
      return;
    }

    String phoneNumber = _controllers.sublist(0, 3).map((controller) => controller.text).join() + '-' +
        _controllers.sublist(3, 7).map((controller) => controller.text).join() + '-' +
        _controllers.sublist(7).map((controller) => controller.text).join();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '전화번호 확인',
          infoLabel: '전화번호가',
          info: phoneNumber,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FifthPage(
                  name: widget.name,
                  birth: widget.birth,
                  ssn: widget.ssn,
                  contact: phoneNumber,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller, FocusNode focusNode, {bool autoFocus = false}) {
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
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 150), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님의\n전화번호를\n입력해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Apple SD Gothic Neo',
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isPhoneEmpty)
                    Text(
                      '전화번호를 정확히 입력해주세요.',
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
                        children: List.generate(3, (index) => _buildPhoneField(_controllers[index], _focusNodes[index], autoFocus: index == 0)),
                      ),
                      Text('-', style: TextStyle(fontSize: 20, color: Color(0xFF001ED6))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) => _buildPhoneField(_controllers[index + 3], _focusNodes[index + 3])),
                      ),
                      Text('-', style: TextStyle(fontSize: 20, color: Color(0xFF001ED6))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) => _buildPhoneField(_controllers[index + 7], _focusNodes[index + 7])),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6),
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,),
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
