import 'package:flutter/material.dart';
import 'training_info_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class TrainingInfoLastPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String trainingName;
  final String date;

  const TrainingInfoLastPage({super.key, required this.userId, required this.userName, required this.trainingName, required this.date});

  @override
  _TrainingInfoLastPageState createState() => _TrainingInfoLastPageState();
}

class _TrainingInfoLastPageState extends State<TrainingInfoLastPage> {
  final TextEditingController _agencyController = TextEditingController();
  bool _isAgencyEmpty = false;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _agencyController.addListener(_updateTextColor);
  }

  @override
  void dispose() {
    _agencyController.removeListener(_updateTextColor);
    _agencyController.dispose();
    super.dispose();
  }

  void _updateTextColor() {
    setState(() {
      _hasInput = _agencyController.text.isNotEmpty;
    });
  }

  Future<void> _sendData() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/training-info/save/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': widget.userId.toString(),
          'trainingName': widget.trainingName,
          'date': widget.date,
          'agency': _agencyController.text,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrainingInfoResultPage(userId: widget.userId, userName: widget.userName)),
        );
      } else {
        print('데이터 저장 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  void _onConfirmAgency() {
    setState(() {
      _isAgencyEmpty = _agencyController.text.isEmpty;
    });

    if (_isAgencyEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '훈련/교육기관 확인',
          infoLabel: '훈련/교육기관이',
          info: _agencyController.text,
          onConfirmed: () {
            _sendData();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 210),
                  Text(
                    '${widget.userName}님,\n해당 훈련/교육의\n주관기관은\n어딘가요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isAgencyEmpty)
                    Text(
                      '주관기관을 정확히 입력해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Container(
                    width: 347,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(
                        color: Color(0xFF001ED6),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _agencyController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: _hasInput ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '주관기관 입력',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 130),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6),
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                      minimumSize: Size(345, 60),
                      shadowColor: Colors.black,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: _onConfirmAgency,
                    child: const Text(
                      '완료',
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
        ),
      ),
    );
  }
}
