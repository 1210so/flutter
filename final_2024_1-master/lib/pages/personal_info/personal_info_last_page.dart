import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class LastPage extends StatefulWidget {
  final String name;
  final String birth;
  final String ssn;
  final String contact;
  final String email;

  const LastPage({
    Key? key,
    required this.name,
    required this.birth,
    required this.ssn,
    required this.contact,
    required this.email,
  }) : super(key: key);

  @override
  _LastPageState createState() => _LastPageState();
}

class _LastPageState extends State<LastPage> {
  final TextEditingController _addressDetailController = TextEditingController();
  String _selectedAddress = '';
  bool _isAddressEmpty = false;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _addressDetailController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _addressDetailController.removeListener(_updateTextColor);
    _addressDetailController.dispose();
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {
      _hasInput = _addressDetailController.text.isNotEmpty;
    });
  }

  Future<void> _sendData(String address) async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/personal-info/save'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': widget.name,
          'birth': widget.birth,
          'ssn': widget.ssn,
          'contact': widget.contact,
          'email': widget.email,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInfoResultPage(
              userId: data['userId'],
            ),
          ),
        );
      } else {
        print('데이터 저장 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  void _onConfirmAddress() {
    setState(() {
      _isAddressEmpty = _selectedAddress.isEmpty;
    });

    if (_isAddressEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '주소 확인',
          infoLabel: '주소가',
          info: '$_selectedAddress ${_addressDetailController.text}',
          onConfirmed: () {
            _sendData('$_selectedAddress ${_addressDetailController.text}');
          },
        ),
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xFF001ED6),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  "주소 정보를\n불러오는 중입니다",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: Color(0xFF001ED6), width: 2),
          ),
        );
      },
    );
  }

  void _onSearchAddress() async {
    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );

    if (model != null) {
      setState(() {
        _selectedAddress = model.address ?? '';
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
                  SizedBox(height: 230), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님은\n어디에\n거주하시나요?',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10), // 텍스트와 입력 칸을 상단에 고정
                  if (_isAddressEmpty)
                    Text(
                      '주소를 정확히 입력해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: _onSearchAddress,
                    child: Container(
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
                        child: Center(
                          child: Text(
                            _selectedAddress.isEmpty ? '주소 검색' : _selectedAddress,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20, // 텍스트의 크기
                              color: _selectedAddress.isNotEmpty ? Color(0xFF001ED6) : Colors.grey, // 텍스트의 색상
                              fontWeight: FontWeight.bold, // 텍스트의 굵기
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                        controller: _addressDetailController, // 입력 컨트롤러 설정
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20, // 입력 텍스트의 크기
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                          fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                        ),
                        decoration: InputDecoration(
                          hintText: '상세 주소 입력', // 입력 필드의 힌트 텍스트
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
                    onPressed: _onConfirmAddress, // 주소 확인 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18, // 버튼 텍스트의 크기
                        fontWeight: FontWeight.bold, // 버튼 텍스트의 굵기
                        color: Colors.white, // 버튼 텍스트의 색상
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // 추가된
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}