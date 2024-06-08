import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class SubjectListPage extends StatefulWidget {
  @override
  _SubjectListPageState createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  Future<List<String>>? _fetchData;
  TextEditingController _searchController = TextEditingController();
  List<String> _subjectNames = [];
  List<String> _filteredSubjectNames = [];

  @override
  void initState() {
    super.initState();
    _fetchData = fetchData();
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<String>> fetchData() async {
    final String rawCsv = await rootBundle.loadString('assets/university_subjects.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(rawCsv);

    // Assuming the first row is the header and we are interested in the column with title "학과명"
    int columnIndex = csvTable[0].indexOf('학과명');
    if (columnIndex == -1) {
      throw Exception('학과명 column not found');
    }

    // Extract the column values (excluding the header)
    List<String> subjectNames = [];
    for (int i = 1; i < csvTable.length; i++) {
      subjectNames.add(csvTable[i][columnIndex]);
    }

    _subjectNames = subjectNames;
    _filteredSubjectNames = subjectNames;

    return subjectNames;
  }

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
