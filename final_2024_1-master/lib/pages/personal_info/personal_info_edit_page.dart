import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class PersonalInfoEditPage extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> personalInfo;

  const PersonalInfoEditPage({super.key, required this.userId, required this.personalInfo});

  @override
  _PersonalInfoEditPageState createState() => _PersonalInfoEditPageState();
}

class _PersonalInfoEditPageState extends State<PersonalInfoEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  late TextEditingController _ssnController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  bool _isNameEmpty = false;
  bool _isBirthEmpty = false;
  bool _isSsnEmpty = false;
  bool _isContactEmpty = false;
  bool _isEmailEmpty = false;
  bool _isAddressEmpty = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.personalInfo['name']);
    _birthController = TextEditingController(text: widget.personalInfo['birth']);
    _ssnController = TextEditingController(text: widget.personalInfo['ssn']);
    _contactController = TextEditingController(text: widget.personalInfo['contact']);
    _emailController = TextEditingController(text: widget.personalInfo['email']);
    _addressController = TextEditingController(text: widget.personalInfo['address']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _ssnController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() {
      _isNameEmpty = _nameController.text.isEmpty;
      _isBirthEmpty = _birthController.text.isEmpty;
      _isSsnEmpty = _ssnController.text.isEmpty;
      _isContactEmpty = _contactController.text.isEmpty;
      _isEmailEmpty = _emailController.text.isEmpty;
      _isAddressEmpty = _addressController.text.isEmpty;
    });

    if (_isNameEmpty || _isBirthEmpty || _isSsnEmpty || _isContactEmpty || _isEmailEmpty || _isAddressEmpty) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/personal-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': widget.userId.toString(),
          'name': _nameController.text,
          'birth': _birthController.text,
          'ssn': _ssnController.text,
          'contact': _contactController.text,
          'email': _emailController.text,
          'address': _addressController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        print('데이터 업데이트 실패');
      }
    } catch (e) {
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
              SizedBox(height: 100),
              Text(
                "틀린 부분을\n수정해주세요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                  height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '이름',
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
                  errorText: _isNameEmpty ? '이름을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _birthController,
                decoration: InputDecoration(
                  labelText: '생년월일',
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
                  errorText: _isBirthEmpty ? '생년월일을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _ssnController,
                decoration: InputDecoration(
                  labelText: '주민등록번호',
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
                  errorText: _isSsnEmpty ? '주민등록번호를 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: '전화번호',
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
                  errorText: _isContactEmpty ? '전화번호를 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일주소',
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
                  errorText: _isEmailEmpty ? '이메일 주소를 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: '주소',
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
                  errorText: _isAddressEmpty ? '주소를 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF001ED6),
                  side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                  minimumSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  shadowColor: Colors.black,
                  // 버튼의 그림자 색상
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



