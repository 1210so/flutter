import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_fifth_page.dart';

// FourthPage : 사용자가 전화번호를 입력하는 페이지
class FourthPage extends StatefulWidget {
  final String name;
  final String birth;
  final String ssn;

  const FourthPage({super.key, required this.name, required this.birth, required this.ssn});

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final TextEditingController _firstPartController = TextEditingController();
  final TextEditingController _secondPartController = TextEditingController();
  final TextEditingController _thirdPartController = TextEditingController();
  final FocusNode _firstPartFocusNode = FocusNode();
  final FocusNode _secondPartFocusNode = FocusNode();
  final FocusNode _thirdPartFocusNode = FocusNode();
  bool _isPhoneEmpty = false;

  // 다음 버튼을 눌렀을 때 호출되는 함수
  void _onNextButtonPressed() {
    setState(() {
      _isPhoneEmpty = _firstPartController.text.isEmpty || _secondPartController.text.isEmpty || _thirdPartController.text.isEmpty;
    });

    if (_isPhoneEmpty) {
      return;
    }

    // 입력된 전화번호를 조합하여 하나의 문자열로 생성
    String phoneNumber = '${_firstPartController.text}-${_secondPartController.text}-${_thirdPartController.text}';

    // 전화번호 확인 페이지로 이동
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

  // 전화번호 입력 필드 UI를 구성하는 함수
  Widget _buildPhonePartField(TextEditingController controller, FocusNode focusNode, int maxLength, {bool autoFocus = false}) {
    return Container(
      width: 100,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        autofocus: autoFocus,
        focusNode: focusNode,
        style: TextStyle(
          fontSize: 35,
          color: Color(0xFF001ED6),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF001ED6),
              width: 2.0,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == maxLength) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  // UI 구성
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
                  SizedBox(height: 230), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님의\n전화번호를\n입력해주세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPhonePartField(_firstPartController, _firstPartFocusNode, 3, autoFocus: true),
                      Text('-', style: TextStyle(fontSize: 24, color: Color(0xFF001ED6))),
                      _buildPhonePartField(_secondPartController, _secondPartFocusNode, 4),
                      Text('-', style: TextStyle(fontSize: 24, color: Color(0xFF001ED6))),
                      _buildPhonePartField(_thirdPartController, _thirdPartFocusNode, 4),
                    ],
                  ),
                  SizedBox(height: 160),
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
