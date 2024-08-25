import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'training_info_first_page.dart';
import 'training_info_edit_page.dart';
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/introduction_info/introduction_info_page.dart';

// 훈련 정보 결과 페이지를 위한 StatefulWidget
class TrainingInfoResultPage extends StatefulWidget {
  final int userId;
  final String userName;

  const TrainingInfoResultPage({Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  _TrainingInfoResultPageState createState() => _TrainingInfoResultPageState();
}

class _TrainingInfoResultPageState extends State<TrainingInfoResultPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

// 서버에서 훈련 정보 데이터 가져오기
  Future<List<Map<String, dynamic>>> _fetchData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/training-info/${widget.userId}'),
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
                        // 훈련 정보 리스트
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var training = data[index];
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
                                      "훈련/교육명: ${training['trainingName']}",
                                      style: TextStyle(
                                        color: Color(0xFF001ED6),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "훈련/교육 일자: ${training['date']}\n훈련/교육 기관: ${training['agency']}",
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
                                            builder: (context) => TrainingInfoEditPage(
                                              userId: widget.userId,
                                              trainingInfos: data,
                                              trainingIndex: index,
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
                        // 훈련/교육 정보 추가 버튼
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
                              MaterialPageRoute(builder: (context) => TrainingInfoFirstPage(userId: widget.userId, userName: widget.userName)),
                            );
                          },
                          child: const Text(
                            '훈련/교육 정보 추가하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF001ED6),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        // 자기소개서 작성 버튼
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
                              MaterialPageRoute(builder: (context) => IntroductionInfoPage(userId: widget.userId, userName: widget.userName)),
                            );
                          },
                          child: const Text(
                            '자기소개서 작성하기',
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
