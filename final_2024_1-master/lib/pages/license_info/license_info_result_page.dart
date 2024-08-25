import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/license_info/license_info_first_page.dart';
import 'license_info_edit_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_first_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class LicenseInfoResultPage extends StatefulWidget {
  final int userId; // 사용자 ID
  final String userName; // 사용자 이름

  const LicenseInfoResultPage({Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  _LicenseInfoResultPageState createState() => _LicenseInfoResultPageState();
}

class _LicenseInfoResultPageState extends State<LicenseInfoResultPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture; // 비동기 데이터 저장 변수

  @override
  void initState() {
    super.initState();
    // 데이터 로딩을 위한 Future 초기화
    _dataFuture = _fetchData();
  }

  // 데이터를 서버에서 가져오는 비동기 함수
  Future<List<Map<String, dynamic>>> _fetchData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/license-info/${widget.userId}'), // 사용자 ID를 포함한 서버 URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 요청 헤더
      },
    );

    if (response.statusCode == 200) {
      // 응답 상태가 200이면 데이터 로딩 성공
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes)); // 응답
      return data.cast<Map<String, dynamic>>(); // 데이터 형변환
    } else {
      // 응답 상태가 200이 아니면 예외 발생
      throw Exception('데이터 페치 실패'); // 데이터 가져오기 실패 시 예외 메시지
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
                            fontWeight: FontWeight.bold,
                            height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var license = data[index];
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
                                      "자격증/면허: ${license['licenseName']}",
                                      style: TextStyle(
                                        color: Color(0xFF001ED6),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "취득일: ${license['date']}\n시행 기관: ${license['agency']}",
                                      style: TextStyle(
                                        color: Color(0xFF001ED6),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit, color: Color(0xFF001ED6)),
                                      onPressed: () async {
                                        bool? result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LicenseInfoEditPage(
                                              userId: widget.userId,
                                              licenseInfos: data,
                                              licenseIndex: index,
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
                              MaterialPageRoute(builder: (context) => LicenseInfoFirstPage(userId: widget.userId, userName: widget.userName)),
                            );
                          },
                          child: const Text(
                            '자격증/면허 정보 추가하기',
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
                              MaterialPageRoute(builder: (context) => TrainingInfoFirstPage(userId: widget.userId, userName: widget.userName)),
                            );
                          },
                          child: const Text(
                            '훈련/교육 정보 입력하기',
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
