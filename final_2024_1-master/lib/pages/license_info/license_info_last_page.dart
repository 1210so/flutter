import 'package:flutter/material.dart';
import 'license_info_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class LicenseInfoLastPage extends StatefulWidget {
  final int userId;
  final String licenseName;
  final String date;
  final String userName;

  const LicenseInfoLastPage({super.key, required this.userId, required this.licenseName, required this.date, required this.userName});

  @override
  _LicenseInfoLastPageState createState() => _LicenseInfoLastPageState();
}

class _LicenseInfoLastPageState extends State<LicenseInfoLastPage> {
  final TextEditingController _agencyController = TextEditingController();
  bool _isAgencyEmpty = false;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _agencyController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _agencyController.removeListener(_updateTextColor);
    _agencyController.dispose();
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {
      _hasInput = _agencyController.text.isNotEmpty;
    });
  }

  Future<void> _sendData() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/license-info/save/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': widget.userId.toString(),
          'licenseName': widget.licenseName,
          'date': widget.date,
          'agency': _agencyController.text,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LicenseInfoResultPage(userId: widget.userId, userName: widget.userName)),
        );
      } else {
        print('데이터 저장 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  void _onConfirmAgency() {
    setState(() {
      _isAgencyEmpty = _agencyController.text.isEmpty;
    });

    if (_isAgencyEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '시행기관 확인',
          infoLabel: '시행기관이',
          info: _agencyController.text,
          onConfirmed: () {
            _sendData();
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
                          fontSize: 20, // 입력 텍스트의 크기
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '시행기관 입력', // 입력 필드의 힌트 텍스트
                          hintStyle: TextStyle(
                            color: Colors.grey, // 힌트 텍스트의 색상
                            fontSize: 20, // 힌트 텍스트의 크기
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
