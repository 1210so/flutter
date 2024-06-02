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

  @override
  void initState() {
    super.initState();
    _highestEduController = TextEditingController(text: widget.academicInfo['highestEdu']);
    _schoolNameController = TextEditingController(text: widget.academicInfo['schoolName']);
    _majorController = TextEditingController(text: widget.academicInfo['major'] ?? '');
    _detailedMajorController = TextEditingController(text: widget.academicInfo['detailedMajor'] ?? '');
  }

  Future<void> _updateData() async {
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
                decoration: const InputDecoration(
                  labelText: '최종 학력',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _schoolNameController,
                decoration: const InputDecoration(
                  labelText: '학교aud',
                  border: OutlineInputBorder(),
                ),
              ),
              if (widget.academicInfo['major'] != null && widget.academicInfo['major'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _majorController,
                      decoration: const InputDecoration(
                        labelText: '전공 계열',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              if (widget.academicInfo['detailedMajor'] != null && widget.academicInfo['detailedMajor'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      controller: _detailedMajorController,
                      decoration: const InputDecoration(
                        labelText: '세부 전공',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 150),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF001ED6),
                  side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
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
