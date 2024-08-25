import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/resume/resume_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/academic_info/academic_info_edit_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_edit_page.dart';
import 'package:final_2024_1/pages/career_info/career_info_edit_page.dart';
import 'package:final_2024_1/pages/license_info/license_info_edit_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_edit_page.dart';
import 'package:final_2024_1/pages/introduction_info/introduction_info_edit_page.dart';

// CheckResumeResultPage : 사용자가 입력한 이력서 정보를 확인하는 페이지
class CheckResumeResultPage extends StatefulWidget {
  final int userId;

  const CheckResumeResultPage({Key? key, required this.userId})
      : super(key: key);

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

  // 서버에서 이력서 데이터를 가져오는 함수
  Future<Map<String, dynamic>> _fetchResumeData() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/resume/${widget.userId}'),
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

  // 이력서 생성을 처리하는 함수
  Future<void> _generateResume() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xFF001ED6),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  "이력서를 생성중입니다.\n잠시 기다려주세요!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: Color(0xFF001ED6), width: 2),
          ),
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/resume/${widget.userId}/uploadView'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String fileUrl = response.body;
        await Future.delayed(Duration(seconds: 50)); // 30초 대기
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResumeResultPage(url: fileUrl, userId: widget.userId,),
          ),
        );
      } else {
        Navigator.of(context).pop();
        throw Exception('파일 업로드 실패: ${response.body}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Text(
                    "입력한 내용을\n확인해주세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildSectionTitle("개인 정보"),
                  SizedBox(height: 30),
                  _buildBox(_buildPersonalInfo(data['PersonalInfo'], context)),
                  SizedBox(height: 40),
                  _buildSectionTitle("학력 정보"),
                  SizedBox(height: 30),
                  if (data['AcademicInfo'] != null)
                    _buildBox(_buildAcademicInfo(data['AcademicInfo'], context)),
                  SizedBox(height: 40),
                  _buildSectionTitle("경력 정보"),
                  _buildCareerInfos(data['CareerInfos'], context),
                  SizedBox(height: 30),
                  _buildSectionTitle("자격/면허 정보"),
                  SizedBox(height: 30),
                  _buildLicenseInfos(data['LicenseInfos'], context),
                  SizedBox(height: 20),
                  _buildSectionTitle("훈련 정보"),
                  _buildTrainingInfos(data['TrainingInfos'], context),
                  SizedBox(height: 40),
                  _buildSectionTitle("자기소개서"),
                  SizedBox(height: 40),
                  _buildBox(_buildIntroductionInfo(
                      data['IntroductionInfo'], context)),
                  SizedBox(height: 70),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "제시해주신 정보가 사실과 달라도\n저희 서비스에서는 책임지지 않습니다.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF001ED6),
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _generateResume,
                          child: const Text(
                            '이력서 생성',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
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
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const CircularProgressIndicator(); // 데이터 로드 중인 경우 로딩 인디케이터 표시
        },
      ),
    );
  }

  // 섹션 타이틀을 빌드하는 함수
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  // 카드 스타일의 박스를 빌드하는 함수
  Widget _buildBox(Widget child) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF001ED6), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  // 개인 정보를 표시하는 위젯을 빌드하는 함수
  Widget _buildPersonalInfo(
      Map<String, dynamic>? personalInfo, BuildContext context) {
    if (personalInfo == null)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  "이름: ${personalInfo['name']}\n"
                      "생년월일: ${personalInfo['birth']}\n"
                      "주민등록번호: ${personalInfo['ssn']}\n"
                      "전화번호: ${personalInfo['contact']}\n"
                      "이메일주소: ${personalInfo['email']}\n"
                      "주소: ${personalInfo['address']}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
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
          ),
        ),
      ],
    );
  }

  // 학력 정보를 표시하는 위젯을 빌드하는 함수
  Widget _buildAcademicInfo(
      Map<String, dynamic>? academicInfo, BuildContext context) {
    if (academicInfo == null)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (academicInfo['highestEdu'] != null && academicInfo['highestEdu'].isNotEmpty)
                      Text(
                        "최종 학력: ${academicInfo['highestEdu']}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (academicInfo['schoolName'] != null && academicInfo['schoolName'].isNotEmpty)
                      Text(
                        "학교 이름: ${academicInfo['schoolName']}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (academicInfo['major'] != null && academicInfo['major'].isNotEmpty)
                      Text(
                        "전공 계열: ${academicInfo['major']}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (academicInfo['detailedMajor'] != null && academicInfo['detailedMajor'].isNotEmpty)
                      Text(
                        "세부 전공: ${academicInfo['detailedMajor']}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (academicInfo['graduationDate'] != null && academicInfo['graduationDate'].isNotEmpty)
                      Text(
                        "졸업 연도: ${academicInfo['graduationDate']}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
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
          ),
        ),
      ],
    );
  }

  // 경력 정보를 표시하는 위젯을 빌드하는 함수
  Widget _buildCareerInfos(List<dynamic>? careerInfos, BuildContext context) {
    if (careerInfos == null || careerInfos.isEmpty)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: careerInfos.length,
      itemBuilder: (context, index) {
        var career = careerInfos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF001ED6), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "근무처: ${career['place']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "근무 기간: ${career['period']}\n업무 내용: ${career['task']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 자격/면허 정보를 표시하는 위젯을 빌드하는 함수
  Widget _buildLicenseInfos(List<dynamic>? licenseInfos, BuildContext context) {
    if (licenseInfos == null || licenseInfos.isEmpty)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: licenseInfos.length,
      itemBuilder: (context, index) {
        var license = licenseInfos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF001ED6), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "자격증/면허: ${license['licenseName']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "취득일: ${license['date']}\n시행 기관: ${license['agency']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 훈련 정보를 표시하는 위젯을 빌드하는 함수
  Widget _buildTrainingInfos(
      List<dynamic>? trainingInfos, BuildContext context) {
    if (trainingInfos == null || trainingInfos.isEmpty)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: trainingInfos.length,
      itemBuilder: (context, index) {
        var training = trainingInfos[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color(0xFF001ED6), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "훈련/교육명: ${training['trainingName']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "훈련/교육 기간: ${training['date']}\n훈련/교육 기관: ${training['agency']}",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 자기소개서를 표시하는 위젯을 빌드하는 함수
  Widget _buildIntroductionInfo(
      Map<String, dynamic>? introductionInfo, BuildContext context) {
    if (introductionInfo == null)
      return Text(
        "정보 없음",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: Text(
                  introductionInfo['gpt'] ?? '자기소개서가 없습니다.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroductionInfoEditPage(
                            userId: widget.userId,
                            initialText: introductionInfo['gpt'] ?? '',
                          ),
                        ));
                    if (result != null && result is String) {
                      setState(() {
                        introductionInfo['gpt'] = result;
                        _saveUpdatedIntroduction(result);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 업데이트된 자기소개서를 저장하는 함수
  Future<void> _saveUpdatedIntroduction(String updatedText) async {
    var url = Uri.parse('$BASE_URL/introduction-info/update/${widget.userId}');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'gpt': updatedText});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.reasonPhrase}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
