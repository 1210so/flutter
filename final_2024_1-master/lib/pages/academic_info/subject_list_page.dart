import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class SubjectListPage extends StatefulWidget {
  @override
  _SubjectListPageState createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  Future<List<String>>? _fetchData;
  // 검색 입력을 위한 TextEditingController
  TextEditingController _searchController = TextEditingController();
  // 전체 학과 이름 리스트
  List<String> _subjectNames = [];
  // 검색 결과에 따른 필터링된 학과 이름 리스트
  List<String> _filteredSubjectNames = [];

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
     // 검색어 입력 시 필터링 함수 연결
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
  // 위젯 dispose 시 컨트롤러 해제
    _searchController.dispose();
    super.dispose();
  }

// CSV 파일에서 데이터를 가져오는 함수
  Future<List<String>> fetchData() async {
  // assets 폴더에서 CSV 파일 로드
    final String rawCsv = await rootBundle.loadString('assets/university_subjects.csv');
    // CSV 데이터를 List로 변환
    List<List<dynamic>> csvTable = CsvToListConverter().convert(rawCsv);

    // '학과명' 열의 인덱스 찾기
    int columnIndex = csvTable[0].indexOf('학과명');
    if (columnIndex == -1) {
      throw Exception('학과명 column not found');
    }

    // 학과명 열의 데이터만 추출 (헤더 제외)
    List<String> subjectNames = [];
    for (int i = 1; i < csvTable.length; i++) {
      subjectNames.add(csvTable[i][columnIndex]);
    }
     // 전체 및 필터링된 리스트 초기화
    _subjectNames = subjectNames;
    _filteredSubjectNames = subjectNames;

    return subjectNames;
  }

// 검색어에 따라 학과 리스트 필터링하는 함수
  void _filterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubjectNames = _subjectNames.where((subject) {
        return subject.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 페이지의 배경색을 하얀색으로 설정
      appBar: AppBar(
        title: Text('세부 전공 검색'),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchData,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '검색',
                      labelStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey, // 회색으로 변경
                        ),
                      ),
                    ),
                  ),
                ),
                // 필터링된 학과 리스트 표시
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredSubjectNames.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white, // 리스트 타일의 배경색을 하얀색으로 설정
                        child: ListTile(
                          title: Text(
                            _filteredSubjectNames[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // 선택된 항목을 이전 페이지로 반환
                            Navigator.pop(context, _filteredSubjectNames[index]);
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Color(0xFF001ED6),
                            width: 2.0,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
