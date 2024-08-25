import 'package:flutter/material.dart';
import 'license_info_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class LicenseInfoLastPage extends StatefulWidget {
  final int userId; // 사용자 ID
  final String licenseName; // 자격증/면허명
  final String date; // 자격증/면허 취득일
  final String userName; // 사용자 이름

  const LicenseInfoLastPage({
    super.key,
    required this.userId,
    required this.licenseName,
    required this.date,
    required this.userName
  });

  @override
  _LicenseInfoLastPageState createState() => _LicenseInfoLastPageState();
}

class _LicenseInfoLastPageState extends State<LicenseInfoLastPage> {
  final TextEditingController _agencyController = TextEditingController(); // 시행기관 입력 컨트롤러
  bool _isAgencyEmpty = false; // 시행기관 입력 여부 확인 변수
  bool _hasInput = false; // 입력 여부 확인 변수

  @override
  void initState() {
    super.initState();
    // 시행기관 입력 컨트롤러에 리스너 추가
    _agencyController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    // 시행기관 입력 컨트롤러의 리스너 제거 및 컨트롤러 폐기
    _agencyController.removeListener(_updateTextColor);
    _agencyController.dispose();
    super.dispose();
  }

  // 입력된 시행기관 텍스트가 변경될 때 호출되는 함수
  void _updateTextColor() {
    setState(() {
      // 시행기관 텍스트 입력 여부에 따라 상태 업데이트
      _hasInput = _agencyController.text.isNotEmpty;
    });
  }

  // 데이터를 서버에 전송하는 비동기 함수
  Future<void> _sendData() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/license-info/save/${widget.userId}'), // 서버 URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // 요청 헤더
        },
        body: jsonEncode(<String, String>{
          'userId': widget.userId.toString(), // 사용자 ID
          'licenseName': widget.licenseName, // 자격증/면허명
          'date': widget.date, // 자격증/면허 취득일
          'agency': _agencyController.text, // 시행기관
        }),
      );

      if (response.statusCode == 201) {
        // 응답 상태가 201이면 성공 처리
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LicenseInfoResultPage(
              userId: widget.userId, // 사용자 ID
              userName: widget.userName, // 사용자 이름
            ),
          ),
        );
      } else {
        print('데이터 저장 실패'); // 데이터 저장 실패 시 메시지 출력
      }
    } catch (e) {
      print('데이터 전송 실패 : $e'); // 데이터 전송 실패 시 예외 메시지 출력
    }
  }

  // '확인' 버튼이 눌렸을 때 실행되는 함수
  void _onConfirmAgency() {
    setState(() {
      _isAgencyEmpty = _agencyController.text.isEmpty; // 시행기관 입력 여부 확인
    });

    if (_isAgencyEmpty) {
      // 시행기관이 입력되지 않은 경우 함수 종료
      return;
    }

    // 시행기관 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '시행기관 확인', // 확인 페이지 제목
          infoLabel: '시행기관이', // 정보 레이블
          info: _agencyController.text, // 입력된 시행기관
          onConfirmed: () {
            _sendData(); // 확인 후 데이터 전송
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
                  SizedBox(height: 200), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.userName}님,\n자격증/면허의\n시행기관은\n어딘가요?',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isAgencyEmpty)
                    Text(
                      '시행기관을 정확히 입력해주세요.',
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
                        controller: _agencyController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32, // 입력 텍스트의 크기
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '시행기관 입력', // 입력 필드의 힌트 텍스트
                          hintStyle: TextStyle(
                            color: Colors.grey, // 힌트 텍스트의 색상
                            fontSize: 32, // 힌트 텍스트의 크기
                            fontWeight: FontWeight.bold, // 힌트 텍스트의 굵기
                          ),
                          border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
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
                    onPressed: _onConfirmAgency, // 시행기관 확인 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '완료',
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
