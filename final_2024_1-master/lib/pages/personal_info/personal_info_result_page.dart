import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/academic_info/academic_info_first_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_edit_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

// PersonalInfoResultPage : 사용자가 입력한 개인 정보를 확인하는 페이지
class PersonalInfoResultPage extends StatefulWidget {
  final int userId;

  const PersonalInfoResultPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PersonalInfoResultPageState createState() => _PersonalInfoResultPageState();
}

class _PersonalInfoResultPageState extends State<PersonalInfoResultPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  // 서버에서 사용자 데이터를 가져오는 함수
  Future<Map<String, dynamic>> _fetchData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/personal-info/${widget.userId}'),
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
                    SizedBox(height: 120),
                    Text(
                      "입력한 내용을\n확인해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
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
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "이름: ${data['name']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          "생년월일: ${data['birth']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          "주민등록번호: ${data['ssn']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          "전화번호: ${data['contact']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          "이메일주소: ${data['email']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                        Text(
                          "주소: ${data['address']}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
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
                            builder: (context) => PersonalInfoEditPage(
                              userId: widget.userId,
                              personalInfo: data,
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
                    // '모든 정보가 맞아요!' 버튼: 학력 정보 입력 페이지로 이동
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcademicInfoFirstPage(
                              userId: widget.userId,
                              userName: data['name'], // 업데이트된 사용자 이름 전달
                            ),
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
}
