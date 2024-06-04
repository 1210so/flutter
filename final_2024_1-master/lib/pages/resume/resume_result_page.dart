import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class ResumeResultPage extends StatelessWidget {
  final int userId;

  const ResumeResultPage({Key? key, required this.userId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchResumeData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/resume/$userId'),
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
        future: _fetchResumeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            var data = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0), // 양쪽 여백 제거
                    child: Container(
                      color: Color(0xFF001ED6), // 파란색 배경
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded( // Expanded로 감싸서 공간을 적절히 사용하도록 함
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  "12쉽소",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "언제나 웃는 얼굴로!",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['PersonalInfo']['name'],
                                  style: TextStyle(
                                    fontSize: 75,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey,
                            width: 150,
                            height: 190,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['PersonalInfo'] != null) ...[
                          SizedBox(height: 16),
                          _buildSectionTitle("인적사항"),
                          _buildPersonalInfo(data['PersonalInfo']),
                          SizedBox(height: 50),
                        ],
                        if (data['IntroductionInfo']?['personality1'] != null) ...[
                          _buildSectionTitle("저, " + data['PersonalInfo']['name'] + "?"),
                          _buildPersonalityInfo(data['IntroductionInfo']),
                          SizedBox(height: 50),
                        ],
                        if (data['AcademicInfo'] != null) ...[
                          _buildSectionTitle("최종학력사항"),
                          _buildAcademicInfo(data['AcademicInfo']),
                          SizedBox(height: 50),
                        ],
                        if (data['CareerInfos'] != null && data['CareerInfos'].isNotEmpty) ...[
                          _buildSectionTitle("경력사항"),
                          _buildCareerInfos(data['CareerInfos']),
                          SizedBox(height: 50),
                        ],
                        if (data['LicenseInfos'] != null && data['LicenseInfos'].isNotEmpty) ...[
                          _buildSectionTitle("자격증/면허"),
                          _buildLicenseInfos(data['LicenseInfos']),
                          SizedBox(height: 50),
                        ],
                        if (data['TrainingInfos'] != null && data['TrainingInfos'].isNotEmpty) ...[
                          _buildSectionTitle("훈련/교육"),
                          _buildTrainingInfos(data['TrainingInfos']),
                          SizedBox(height: 50),
                        ],
                        if (data['IntroductionInfo'] != null) ...[
                          _buildSectionTitle("자기소개서"),
                          _buildIntroductionInfo(data['IntroductionInfo']),
                        ],
                        Divider(color: Colors.grey, thickness: 3.0),
                        // 다른 섹션들...
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8), // 간격을 줄이기 위해 추가
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 3.0,
              height: 1, // 높이 줄이기
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(Map<String, dynamic>? personalInfo) {
    if (personalInfo == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("이름", personalInfo['name']),
          _buildInfoRow("생년월일", personalInfo['birth']),
          _buildInfoRow("주민등록번호", personalInfo['ssn']),
          _buildInfoRow("연락처", personalInfo['contact']),
          _buildInfoRow("이메일", personalInfo['email']),
          _buildInfoRow("주소", personalInfo['address']),
        ],
      ),
    );
  }

  Widget _buildPersonalityInfo(Map<String, dynamic>? introductionInfo) {
    if (introductionInfo == null || introductionInfo['personality1'] == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChip(introductionInfo['personality1']),
          SizedBox(height: 10),
          _buildChip(introductionInfo['personality2']),
          SizedBox(height: 10),
          _buildChip(introductionInfo['personality3']),
        ],
      ),
    );
  }

  Widget _buildAcademicInfo(Map<String, dynamic>? academicInfo) {
    if (academicInfo == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("학교명", academicInfo['schoolName']),
          if (academicInfo['detailedMajor'] != null && academicInfo['detailedMajor'].isNotEmpty)
            _buildInfoRow("전공명", academicInfo['detailedMajor']),
        ],
      ),
    );
  }

  Widget _buildCareerInfos(List<dynamic>? careerInfos) {
    if (careerInfos == null || careerInfos.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        children: careerInfos.map((career) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChip(career['place']),
                    SizedBox(width: 8),
                    Text(
                      "에서",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0), // 간격 추가
                Row(
                  children: [
                    _buildChip(career['period']),
                    SizedBox(width: 8),
                    Text(
                      "동안",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0), // 간격 추가
                Row(
                  children: [
                    _buildChip(career['task']),
                    SizedBox(width: 8),
                    Expanded(
                      // Expanded로 줄 바꿈 방지
                      child: Text(
                        "업무를 맡았습니다.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (career != careerInfos.last) // 마지막 항목이 아닌 경우에만 구분선 추가
                  Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 0,
                      endIndent: 16), // 각 경력 사이의 구분선
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLicenseInfos(List<dynamic>? licenseInfos) {
    if (licenseInfos == null || licenseInfos.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        children: licenseInfos.map((license) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("자격증/면허명", license['licenseName']),
                _buildInfoRow("취득일", license['date']),
                _buildInfoRow("시행 기관", license['agency']),
                if (license != licenseInfos.last) // 마지막 항목이 아닌 경우에만 구분선 추가
                  Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 0,
                      endIndent: 16), // 각 자격증 사이의 구분선
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrainingInfos(List<dynamic>? trainingInfos) {
    if (trainingInfos == null || trainingInfos.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 30.0), // 전체 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
      child: Column(
        children: trainingInfos.map((training) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("훈련/교육명", training['trainingName']),
                _buildInfoRow("훈련/교육 일자", training['date']),
                _buildInfoRow("훈련/교육 기관", training['agency']),
                if (training != trainingInfos.last) // 마지막 항목이 아닌 경우에만 구분선 추가
                  Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 0,
                      endIndent: 16), // 각 자격증 사이의 구분선
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIntroductionInfo(Map<String, dynamic>? introductionInfo) {
    if (introductionInfo == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), // 좌우 동일한 여백
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            introductionInfo['gpt'] ?? '자기소개서가 없습니다.',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Center(
        // 중앙 정렬을 위해 Center 위젯 추가
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 2.0), // 테두리 두껍게
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Center(
              // 중앙 정렬을 위해 Center 위젯 추가
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 20, // 글씨 크기 확대
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0), // 내용의 시작점을 더 오른쪽으로 옮기기 위해 추가
              child: Text(
                value ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20, // 글씨 크기 확대
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
