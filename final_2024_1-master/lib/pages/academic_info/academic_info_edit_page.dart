import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class AcademicInfoEditPage extends StatefulWidget {
  final int userId;
  final Map<String, dynamic> academicInfo;

  const AcademicInfoEditPage({super.key, required this.userId, required this.academicInfo});

  @override
  _AcademicInfoEditPageState createState() => _AcademicInfoEditPageState();
}

class _AcademicInfoEditPageState extends State<AcademicInfoEditPage> {
  late TextEditingController _highestEduController;
  late TextEditingController _schoolNameController;
  late TextEditingController _majorController;
  late TextEditingController _detailedMajorController;
  late TextEditingController _graduationDateController;
  bool _isHighestEduEmpty = false;
  bool _isSchoolNameEmpty = false;
  bool _isMajorEmpty = false;
  bool _isDetailedMajorEmpty = false;
  bool _isGraduationDateEmpty = false;

  @override
  void initState() {
    super.initState();
    _highestEduController = TextEditingController(text: widget.academicInfo['highestEdu']);
    _schoolNameController = TextEditingController(text: widget.academicInfo['schoolName']);
    _majorController = TextEditingController(text: widget.academicInfo['major'] ?? '');
    _detailedMajorController = TextEditingController(text: widget.academicInfo['detailedMajor'] ?? '');
    _graduationDateController = TextEditingController(text: widget.academicInfo['graduationDate'] ?? '');
  }

  @override
  void dispose() {
    _highestEduController.dispose();
    _schoolNameController.dispose();
    _majorController.dispose();
    _detailedMajorController.dispose();
    _graduationDateController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() {
      _isHighestEduEmpty = _highestEduController.text.isEmpty;
      _isSchoolNameEmpty = _schoolNameController.text.isEmpty;
      _isMajorEmpty = _majorController.text.isEmpty;
      _isDetailedMajorEmpty = _detailedMajorController.text.isEmpty;
      _isGraduationDateEmpty = _graduationDateController.text.isEmpty;
    });

    if (_isHighestEduEmpty || _isSchoolNameEmpty || (widget.academicInfo['highestEdu'] == '대학교' || widget.academicInfo['highestEdu'] == '대학원') && _isGraduationDateEmpty) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/academic-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': widget.userId,
          'highestEdu': _highestEduController.text,
          'schoolName': _schoolNameController.text,
          'major': _majorController.text,
          'detailedMajor': _detailedMajorController.text,
          'graduationDate': _graduationDateController.text,
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
              SizedBox(height: 150),
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
              SizedBox(height: 50),
              TextField(
                controller: _highestEduController,
                decoration: InputDecoration(
                  labelText: '최종 학력',
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
                  errorText: _isHighestEduEmpty ? '최종 학력을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _schoolNameController,
                decoration: InputDecoration(
                  labelText: '학교명',
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
                  errorText: _isSchoolNameEmpty ? '학교명을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              if (widget.academicInfo['major'] != null && widget.academicInfo['major'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _majorController,
                      decoration: InputDecoration(
                        labelText: '전공 계열',
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
                        errorText: _isMajorEmpty ? '전공 계열을 입력해주세요' : null,
                      ),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (widget.academicInfo['detailedMajor'] != null && widget.academicInfo['detailedMajor'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _detailedMajorController,
                      decoration: InputDecoration(
                        labelText: '세부 전공',
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
                        errorText: _isDetailedMajorEmpty ? '세부 전공을 입력해주세요' : null,
                      ),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              if (widget.academicInfo['graduationDate'] != null && widget.academicInfo['graduationDate'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _graduationDateController,
                      decoration: InputDecoration(
                        labelText: '졸업 연도',
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
                        errorText: _isGraduationDateEmpty ? '졸업 연도를 입력해주세요' : null,
                      ),
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
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
                  shadowColor: Colors.black,
                  elevation: 6,
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
