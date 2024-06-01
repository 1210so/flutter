import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/academic_info/academic_info_first_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_edit_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<Map<String, dynamic>> _fetchData() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:50369/personal-info/${widget.userId}'),
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
                    SizedBox(height: 100),
                    Text(
                      "입력한 내용을\n확인해주세요",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                        height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "정보가 틀린 부분이 있어도\n12쉽소는 책임지지 않아요.\n틀린 부분을 확인해주세요.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                        height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      "이름: ${data['name']}\n생년월일: ${data['birth']}\n주민등록번호: ${data['ssn']}\n전화번호: ${data['contact']}\n이메일주소: ${data['email']}\n주소: ${data['address']}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                        height: 1.7, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                      ),
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
                            builder: (context) => AcademicInfoFirstPage(userId: widget.userId),
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
