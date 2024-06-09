import 'package:flutter/material.dart';
import 'career_info_result_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class CareerInfoLastPage extends StatefulWidget {
  final int userId;
  final String place;
  final String period;
  final String userName;
  const CareerInfoLastPage({super.key, required this.userId, required this.place, required this.period, required this.userName});

  @override
  _CareerInfoLastPageState createState() => _CareerInfoLastPageState();
}

class _CareerInfoLastPageState extends State<CareerInfoLastPage> {
  final TextEditingController _taskController = TextEditingController();
  bool _isTaskEmpty = false;
  bool _hasInputTask = false;

  @override
  void initState() {
    super.initState();
    _taskController.addListener(_updateTaskTextColor);
  }

  @override
  void dispose() {
    _taskController.removeListener(_updateTaskTextColor);
    _taskController.dispose();
    super.dispose();
  }

  void _updateTaskTextColor() {
    setState(() {
      _hasInputTask = _taskController.text.isNotEmpty;
    });
  }

  Future<void> _sendData() async {
    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/career-info/save/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userId': widget.userId.toString(),
          'place': widget.place,
          'period': widget.period,
          'task': _taskController.text,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CareerInfoResultPage(userId: widget.userId, userName: widget.userName,)),
        );
      } else {
        print('데이터 저장 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  void _onNextButtonPressed() {
    setState(() {
      _isTaskEmpty = _taskController.text.isEmpty;
    });

    if (_isTaskEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '업무 내용 확인',
          infoLabel: '업무 내용이',
          info: _taskController.text,
          onConfirmed: _sendData,
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
                  SizedBox(height: 230),
                  Text(
                    '${widget.userName}님은\n어떤 업무를\n맡으셨나요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isTaskEmpty)
                    Text(
                      '업무 내용을 정확히 입력해주세요.',
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
                        controller: _taskController,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          color: _hasInputTask ? Color(0xFF001ED6) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '업무 내용',
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
                  SizedBox(height: 180),
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
                    onPressed: _onNextButtonPressed,
                    child: const Text(
                      '다음',
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
