import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/career_info/career_info_first_page.dart';
import 'package:final_2024_1/pages/academic_info/academic_info_edit_page.dart'; // 추가
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class AcademicInfoResultPage extends StatefulWidget {
  final int userId;
  final String highestEdu;
  final String schoolName;
  final String major;
  final String userName;

  const AcademicInfoResultPage({
    Key? key,
    required this.userId,
    required this.highestEdu,
    required this.schoolName,
    required this.major,
    required this.userName,
  }) : super(key: key);

  @override
  _AcademicInfoResultPageState createState() => _AcademicInfoResultPageState();
}

class _AcademicInfoResultPageState extends State<AcademicInfoResultPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/academic-info/${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('데이터 페치 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            var data = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 170),
                    Text(
                      "입력한 내용을\n확인해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "잘못 입력하신 정보에 대해서는\n책임지지 않습니다.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      _buildAcademicInfoText(data),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        height: 1.7, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                      ),
                    ),
                    SizedBox(height: 80),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF001ED6), width: 2),
                        minimumSize: Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcademicInfoEditPage(
                              userId: widget.userId,
                              academicInfo: data,
                            ),
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            _dataFuture = _fetchData();
                          });
                        }
                      },
                      child: const Text(
                        '수정하고 싶은 부분이 있어요',
                        style: TextStyle(
                          color: Color(0xFF001ED6),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
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
                        shadowColor: Colors.black, // 버튼의 그림자 색상
                        elevation: 6, // 버튼의 그림자 높이,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CareerInfoFirstPage(userId: widget.userId, userName: widget.userName,),
                          ),
                        );
                      },
                      child: const Text(
                        '모든 정보가 맞아요!',
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
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  String _buildAcademicInfoText(Map<String, dynamic> data) {
    List<String> info = [];

    info.add("최종 학력: ${data['highestEdu']}");
    info.add("학교 이름: ${data['schoolName']}");
    if (data['major'] != null && data['major'].isNotEmpty) {
      info.add("전공 계열: ${data['major']}");
    }
    if (data['detailedMajor'] != null && data['detailedMajor'].isNotEmpty) {
      info.add("세부 전공: ${data['detailedMajor']}");
    }
    if (data['graduationDate'] != null && data['graduationDate'].isNotEmpty) {
      info.add("졸업 연도: ${data['graduationDate']}");
    }

    return info.join("\n");
  }
}
