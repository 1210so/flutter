import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/license_info/license_info_first_page.dart';
import 'career_info_edit_page.dart';
import 'package:final_2024_1/pages/career_info/career_info_first_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class CareerInfoResultPage extends StatefulWidget {
  final int userId;

  const CareerInfoResultPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CareerInfoResultPageState createState() => _CareerInfoResultPageState();
}

class _CareerInfoResultPageState extends State<CareerInfoResultPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/career-info/${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('데이터 페치 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              var data = snapshot.data!;
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100),
                        Text(
                          '입력한 내용을\n확인해주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Apple SD Gothic Neo',
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '잘못 입력하신 정보에 대해서는\n책임지지 않습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                            fontWeight: FontWeight.bold,
                            height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var career = data[index];
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24.0),
                                    border: Border.all(
                                      color: Color(0xFF001ED6),
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      "근무처: ${career['place']}",
                                      style: TextStyle(
                                        color: Color(0xFF001ED6),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "근무 기간: ${career['period']}\n업무 내용: ${career['task']}",
                                      style: TextStyle(
                                        color: Color(0xFF001ED6),
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit, color: Color(0xFF001ED6)),
                                      onPressed: () async {
                                        bool? result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CareerInfoEditPage(
                                              userId: widget.userId,
                                              careerInfos: data,
                                              careerIndex: index,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          setState(() {
                                            _dataFuture = _fetchData();
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            );
                          },
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CareerInfoFirstPage(userId: widget.userId)),
                            );
                          },
                          child: const Text(
                            '경력 정보 추가하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF001ED6),
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
                              MaterialPageRoute(builder: (context) => LicenseInfoFirstPage(userId: widget.userId)),
                            );
                          },
                          child: const Text(
                            '자격증/면허 정보 입력하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
