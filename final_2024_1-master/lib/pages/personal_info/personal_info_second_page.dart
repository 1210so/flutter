import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 지정하기 위해 intl 패키지 사용
import 'personal_info_confirmation_page.dart';
import 'personal_info_third_page.dart';

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
            primaryColor: Color(0xFF001ED6), // 포인트 색상
            hintColor: Color(0xFF001ED6), // 포인트 색상
            colorScheme: ColorScheme.light(primary: Color(0xFF001ED6)), // 포인트 색상
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // 포인트 색상
            dialogBackgroundColor: Colors.white, // 배경 색상
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
                  SizedBox(height: 240), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님은\n언제\n태어나셨나요?',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
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
                        controller: _birthController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28, // 입력 텍스트의 크기
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '생년월일 선택하기', // 입력 필드의 힌트 텍스트
                          hintStyle: TextStyle(
                            color: Colors.grey, // 힌트 텍스트의 색상
                            fontSize: 28, // 힌트 텍스트의 크기
                            fontWeight: FontWeight.bold, // 힌트 텍스트의 굵기
                          ),
                          border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                        ),
                        readOnly: true, // 사용자가 직접 입력하지 못하도록 설정
                        onTap: () => _selectDate(context), // 텍스트 필드를 탭하면 생년월일 선택 함수 호출
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
