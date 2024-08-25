import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class LicenseInfoEditPage extends StatefulWidget {
  final int userId;
  final List<dynamic> licenseInfos;
  final int licenseIndex;

  const LicenseInfoEditPage({super.key, required this.userId, required this.licenseInfos, required this.licenseIndex});

  @override
  _LicenseInfoEditPageState createState() => _LicenseInfoEditPageState();
}

class _LicenseInfoEditPageState extends State<LicenseInfoEditPage> {
  late TextEditingController _licenseNameController; // 자격증/면허명 입력 컨트롤러
  late TextEditingController _dateController; // 취득일 입력 컨트롤러
  late TextEditingController _agencyController; // 시행기관 입력 컨트롤러
  bool _isLicenseNameEmpty = false; // 자격증/면허명 입력 여부 확인 플래그
  bool _isDateEmpty = false; // 취득일 입력 여부 확인 플래그
  bool _isAgencyEmpty = false; // 시행기관 입력 여부 확인 플래그

  @override
  void initState() {
    super.initState();
    // 초기화: 위젯의 자격증/면허 정보와 인덱스를 이용해 텍스트 컨트롤러 초기화
    var license = widget.licenseInfos[widget.licenseIndex];
    _licenseNameController = TextEditingController(text: license['licenseName']);
    _dateController = TextEditingController(text: license['date']);
    _agencyController = TextEditingController(text: license['agency']);
  }

  @override
  void dispose() {
    // 컨트롤러 리소스 해제
    _licenseNameController.dispose();
    _dateController.dispose();
    _agencyController.dispose();
    super.dispose();
  }

  // 데이터를 서버에 업데이트하는 비동기 함수
  Future<void> _updateData() async {
    setState(() {
      // 입력 필드가 비어 있는지 확인
      _isLicenseNameEmpty = _licenseNameController.text.isEmpty;
      _isDateEmpty = _dateController.text.isEmpty;
      _isAgencyEmpty = _agencyController.text.isEmpty;
    });

    // 필드 중 하나라도 비어 있으면 업데이트 중지
    if (_isLicenseNameEmpty || _isDateEmpty || _isAgencyEmpty) {
      return;
    }

    try {
      // 업데이트할 자격증/면허 정보 생성
      var updatedLicense = {
        'licenseName': _licenseNameController.text,
        'date': _dateController.text,
        'agency': _agencyController.text,
      };
      // 위젯의 자격증/면허 정보 목록에서 현재 항목 업데이트
      widget.licenseInfos[widget.licenseIndex] = updatedLicense;

      // 서버에 POST 요청으로 데이터 전송
      var response = await http.post(
        Uri.parse('$BASE_URL/license-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(widget.licenseInfos), // 업데이트된 데이터 포함
      );

      // 응답 상태가 200이면 성공적으로 업데이트
      if (response.statusCode == 200) {
        Navigator.pop(context, true); // 이전 화면으로 돌아가면서 성공 상태 반환
      } else {
        // 응답 상태가 200이 아니면 실패 로그 출력
        print('데이터 업데이트 실패');
      }
    } catch (e) {
      // 데이터 전송 중 오류 발생 시 오류 메시지 출력
      print('데이터 전송 실패 : $e');
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 150),
              Text(
                "틀린 부분을\n수정해주세요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: _licenseNameController,
                decoration: InputDecoration(
                  labelText: '자격증/면허명',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isLicenseNameEmpty ? '자격증/면허명을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: '취득일',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isDateEmpty ? '취득일을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _agencyController,
                decoration: InputDecoration(
                  labelText: '시행 기관',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isAgencyEmpty ? '시행 기관을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF001ED6),
                  side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  shadowColor: Colors.black, // 버튼의 그림자 색상
                  elevation: 6, // 버튼의 그림자 높이,
                ),
                onPressed: _updateData,
                child: const Text(
                  '수정 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
