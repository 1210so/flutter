import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/academic_info/academic_info_edit_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_edit_page.dart';
import 'package:final_2024_1/pages/career_info/career_info_edit_page.dart';
import 'package:final_2024_1/pages/license_info/license_info_edit_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_edit_page.dart';
import 'package:final_2024_1/pages/resume/resume_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckResumeResultPage extends StatefulWidget {
  final int userId;

  const CheckResumeResultPage({Key? key, required this.userId}) : super(key: key);

  @override
  _CheckResumeResultPageState createState() => _CheckResumeResultPageState();
}

class _CheckResumeResultPageState extends State<CheckResumeResultPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchResumeData();
  }

  Future<Map<String, dynamic>> _fetchResumeData() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:50369/resume/${widget.userId}'),
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

  void _generateResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeResultPage(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이력서 결과 확인")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            var data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("개인 정보"),
                  _buildBox(_buildPersonalInfo(data['PersonalInfo'], context)),
                  SizedBox(height: 20),
                  _buildSectionTitle("학력 정보"),
                  _buildBox(_buildAcademicInfo(data['AcademicInfo'], context)),
                  SizedBox(height: 20),
                  _buildSectionTitle("경력 정보"),
                  _buildCareerInfos(data['CareerInfos'], context),
                  SizedBox(height: 20),
                  _buildSectionTitle("자격/면허 정보"),
                  _buildLicenseInfos(data['LicenseInfos'], context),
                  SizedBox(height: 20),
                  _buildSectionTitle("훈련 정보"),
                  _buildTrainingInfos(data['TrainingInfos'], context),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "마지막으로 틀린 부분이 있다면 수정해주시고,\n이력서 정보가 맞으시면 이력서 생성 버튼을 눌러주세요",
                          style: TextStyle(fontSize: 16.0, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _generateResume,
                          child: const Text('이력서 생성'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBox(Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildPersonalInfo(Map<String, dynamic>? personalInfo, BuildContext context) {
    if (personalInfo == null) return Text("개인 정보 없음");
    return Column(
      children: [
        ListTile(
          subtitle: Text(
            "이름: ${personalInfo['name']}\n"
                "생년월일: ${personalInfo['birth']}\n"
                "주민등록번호: ${personalInfo['ssn']}\n"
                "전화번호: ${personalInfo['contact']}\n"
                "이메일주소: ${personalInfo['email']}\n"
                "주소: ${personalInfo['address']}",
            style: TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalInfoEditPage(
                    userId: widget.userId,
                    personalInfo: personalInfo,
                  ),
                ),
              );
              if (result == true) {
                setState(() {
                  _dataFuture = _fetchResumeData();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAcademicInfo(Map<String, dynamic>? academicInfo, BuildContext context) {
    if (academicInfo == null) return Text("학력 정보 없음");
    return Column(
      children: [
        ListTile(
          subtitle: Text(
            "최종 학력: ${academicInfo['highestEdu']}\n"
                "학교 이름: ${academicInfo['schoolName']}\n"
                "전공 계열: ${academicInfo['major']}\n"
                "세부 전공: ${academicInfo['detailedMajor']}",
            style: TextStyle(fontSize: 16.0, color: Colors.black87),
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcademicInfoEditPage(
                    userId: widget.userId,
                    academicInfo: academicInfo,
                  ),
                ),
              );
              if (result == true) {
                setState(() {
                  _dataFuture = _fetchResumeData();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCareerInfos(List<dynamic>? careerInfos, BuildContext context) {
    if (careerInfos == null || careerInfos.isEmpty) return Text("경력 정보 없음");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: careerInfos.length,
      itemBuilder: (context, index) {
        var career = careerInfos[index];
        return Column(
          children: [
            Card(
              child: ListTile(
                title: Text("근무처: ${career['place']}"),
                subtitle: Text("근무 기간: ${career['period']}\n업무 내용: ${career['task']}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CareerInfoEditPage(
                          userId: widget.userId,
                          careerInfos: careerInfos,
                          careerIndex: index,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _dataFuture = _fetchResumeData();
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10), // 항목 간의 간격 추가
          ],
        );
      },
    );
  }

  Widget _buildLicenseInfos(List<dynamic>? licenseInfos, BuildContext context) {
    if (licenseInfos == null || licenseInfos.isEmpty) return Text("자격/면허 정보 없음");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: licenseInfos.length,
      itemBuilder: (context, index) {
        var license = licenseInfos[index];
        return Column(
          children: [
            Card(
              child: ListTile(
                title: Text("자격증/면허: ${license['licenseName']}"),
                subtitle: Text("취득일: ${license['date']}\n시행 기관: ${license['agency']}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LicenseInfoEditPage(
                          userId: widget.userId,
                          licenseInfos: licenseInfos,
                          licenseIndex: index,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _dataFuture = _fetchResumeData();
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10), // 항목 간의 간격 추가
          ],
        );
      },
    );
  }

  Widget _buildTrainingInfos(List<dynamic>? trainingInfos, BuildContext context) {
    if (trainingInfos == null || trainingInfos.isEmpty) return Text("훈련/교육 정보 없음");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trainingInfos.length,
      itemBuilder: (context, index) {
        var training = trainingInfos[index];
        return Column(
          children: [
            Card(
              child: ListTile(
                title: Text("훈련/교육명: ${training['trainingName']}"),
                subtitle: Text("훈련/교육 기간: ${training['date']}\n훈련/교육 기관: ${training['agency']}"),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingInfoEditPage(
                          userId: widget.userId,
                          trainingInfos: trainingInfos,
                          trainingIndex: index,
                        ),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _dataFuture = _fetchResumeData();
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10), // 항목 간의 간격 추가
          ],
        );
      },
    );
  }
}


