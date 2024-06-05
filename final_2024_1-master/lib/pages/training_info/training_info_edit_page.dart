import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class TrainingInfoEditPage extends StatefulWidget {
  final int userId;
  final List<dynamic> trainingInfos;
  final int trainingIndex;

  const TrainingInfoEditPage({super.key, required this.userId, required this.trainingInfos, required this.trainingIndex});

  @override
  _TrainingInfoEditPageState createState() => _TrainingInfoEditPageState();
}

class _TrainingInfoEditPageState extends State<TrainingInfoEditPage> {
  late TextEditingController _trainingNameController;
  late TextEditingController _dateController;
  late TextEditingController _agencyController;
  bool _isTrainingNameEmpty = false;
  bool _isDateEmpty = false;
  bool _isAgencyEmpty = false;

  @override
  void initState() {
    super.initState();
    var training = widget.trainingInfos[widget.trainingIndex];
    _trainingNameController = TextEditingController(text: training['trainingName']);
    _dateController = TextEditingController(text: training['date']);
    _agencyController = TextEditingController(text: training['agency']);
  }

  @override
  void dispose() {
    _trainingNameController.dispose();
    _dateController.dispose();
    _agencyController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() {
      _isTrainingNameEmpty = _trainingNameController.text.isEmpty;
      _isDateEmpty = _dateController.text.isEmpty;
      _isAgencyEmpty = _agencyController.text.isEmpty;
    });

    if (_isTrainingNameEmpty || _isDateEmpty || _isAgencyEmpty) {
      return;
    }

    try {
      var updatedTraining = {
        'trainingName': _trainingNameController.text,
        'date': _dateController.text,
        'agency': _agencyController.text,
      };
      widget.trainingInfos[widget.trainingIndex] = updatedTraining;

      var response = await http.post(
        Uri.parse('$BASE_URL/training-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(widget.trainingInfos),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        print('데이터 업데이트 실패');
      }
    } catch (e) {
      print('데이터 전송 실패 : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 150),
              Text(
                "틀린 부분을\n수정해주세요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Apple SD Gothic Neo', // 텍스트 폰트
                  height: 1.2, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: _trainingNameController,
                decoration: InputDecoration(
                  labelText: '훈련명',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isTrainingNameEmpty ? '훈련명을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: '훈련 기간',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isDateEmpty ? '훈련 기간을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _agencyController,
                decoration: InputDecoration(
                  labelText: '훈련 기관',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001ED6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF001ED6), width: 3.0),
                  ),
                  errorText: _isAgencyEmpty ? '훈련 기관을 입력해주세요' : null,
                ),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              ElevatedButton(
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
                onPressed: _updateData,
                child: const Text(
                  '수정 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
