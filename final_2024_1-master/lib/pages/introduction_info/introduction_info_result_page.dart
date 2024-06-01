import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/pages/resume/check_resume_result_page.dart';
import 'introduction_info_edit_page.dart';

class IntroductionInfoResultPage extends StatefulWidget {
  final int userId;
  final String introductionText;

  const IntroductionInfoResultPage({super.key, required this.userId, required this.introductionText});

  @override
  _IntroductionInfoResultPageState createState() => _IntroductionInfoResultPageState();
}

class _IntroductionInfoResultPageState extends State<IntroductionInfoResultPage> {
  late String _introductionText;

  @override
  void initState() {
    super.initState();
    _introductionText = widget.introductionText;
  }

  Future<void> _updateIntroduction(String newText) async {
    var url = Uri.parse('http://10.0.2.2:50369/introduction-info/update/${widget.userId}');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'gpt': newText});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        setState(() {
          _introductionText = newText;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('자기소개서가 성공적으로 업데이트되었습니다.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.reasonPhrase}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _editIntroduction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroductionInfoEditPage(
          userId: widget.userId,
          initialText: _introductionText,
        ),
      ),
    );

    if (result != null && result is String) {
      _updateIntroduction(result);
    }
  }

  void _goToResumeCheck() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckResumeResultPage(userId: widget.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자기소개서 결과"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '작성된 자기소개서',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _introductionText.trim(),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editIntroduction,
                  child: const Text('자기소개서 수정'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _goToResumeCheck,
                  child: const Text('최종 이력서 정보 확인하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
