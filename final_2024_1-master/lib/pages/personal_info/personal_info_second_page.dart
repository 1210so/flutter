import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 지정하기 위해 intl 패키지 사용
import 'personal_info_confirmation_page.dart';
import 'personal_info_third_page.dart';

// SecondPage: 사용자가 생년월일을 입력하는 페이지
class SecondPage extends StatefulWidget {
  final String name;
  const SecondPage({super.key, required this.name});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _birthController = TextEditingController();
  bool _isBirthEmpty = false; // 생년월일이 비어 있는지 여부를 확인하는 변수
  bool _hasInput = false; // 생년월일이 입력되었는지 여부를 확인하는 변수

  @override
  void initState() {
    super.initState();
    _birthController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _birthController.removeListener(_updateTextColor);
    _birthController.dispose();
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {
      _hasInput = _birthController.text.isNotEmpty;
    });
  }

  void _onNextButtonPressed() {
    // 다음 버튼을 눌렀을 때 실행되는 함수
    setState(() {
      _isBirthEmpty = _birthController.text.isEmpty;
    });

    if (_isBirthEmpty) {
      return;
    }

    // 생년월일 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '생년월일 확인',
          infoLabel: '생년월일이',
          info: _birthController.text,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThirdPage(name: widget.name, birth: _birthController.text),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // 생년월일 선택 함수
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1950, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'), // 한글 로케일 설정
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF001ED6),
            hintColor: Color(0xFF001ED6),
            colorScheme: ColorScheme.light(primary: Color(0xFF001ED6)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthController.text = DateFormat('yyyy년 MM월 dd일', 'ko_KR').format(picked); // 선택한 날짜를 형식화하여 텍스트 필드에 설정
      });
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
                  SizedBox(height: 240),
                  Text(
                    '${widget.name}님은\n언제\n태어나셨나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isBirthEmpty)
                    Text(
                      '생년월일을 정확히 입력해주세요.',
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _birthController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '생년월일 선택하기',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context), // 텍스트 필드를 탭하면 생년월일 선택 함수 호출
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
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
