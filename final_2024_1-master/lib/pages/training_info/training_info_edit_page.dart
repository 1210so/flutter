import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

// 사용자의 훈련 정보를 수정할 수 있는 StatefulWidget 클래스
class TrainingInfoEditPage extends StatefulWidget {
  final int userId;
  final List<dynamic> trainingInfos;
  final int trainingIndex; // 수정하려는 특정 훈련 정보의 인덱스

  const TrainingInfoEditPage({super.key, required this.userId, required this.trainingInfos, required this.trainingIndex});

  @override
  _TrainingInfoEditPageState createState() => _TrainingInfoEditPageState();
}

// StatefulWidget의 상태 관리 클래스
class _TrainingInfoEditPageState extends State<TrainingInfoEditPage> {
  late TextEditingController _trainingNameController; // 훈련명 입력을 관리하는 컨트롤러
  late TextEditingController _dateController; // 훈련 기간 입력을 관리하는 컨트롤러
  late TextEditingController _agencyController; // 훈련 기관 입력을 관리하는 컨트롤러
  bool _isTrainingNameEmpty = false; // 훈련명이 비어있는지 여부
  bool _isDateEmpty = false; // 훈련 기간이 비어있는지 여부
  bool _isAgencyEmpty = false; // 훈련 기관이 비어있는지 여부

  @override
  void initState() {
    super.initState();
    // 현재 편집 중인 훈련 정보를 가져와서 각 입력 필드에 초기화
    var training = widget.trainingInfos[widget.trainingIndex];
    _trainingNameController = TextEditingController(text: training['trainingName']);
    _dateController = TextEditingController(text: training['date']);
    _agencyController = TextEditingController(text: training['agency']);
  }

  @override
  void dispose() {
  // 각 컨트롤러를 해제하여 메모리 누수 방지
    _trainingNameController.dispose();
    _dateController.dispose();
    _agencyController.dispose();
    super.dispose();
  }

// 서버에 데이터를 업데이트하는 비동기 함수
  Future<void> _updateData() async {
    setState(() {
    // 필드가 비어있는지 여부를 확인
      _isTrainingNameEmpty = _trainingNameController.text.isEmpty;
      _isDateEmpty = _dateController.text.isEmpty;
      _isAgencyEmpty = _agencyController.text.isEmpty;
    });

    if (_isTrainingNameEmpty || _isDateEmpty || _isAgencyEmpty) {
       // 만약 하나라도 비어있다면 함수를 종료
      return;
    }

    try {
    // 수정된 훈련 정보 데이터
      var updatedTraining = {
        'trainingName': _trainingNameController.text,
        'date': _dateController.text,
        'agency': _agencyController.text,
      };
      // 수정된 정보를 리스트에 업데이트
      widget.trainingInfos[widget.trainingIndex] = updatedTraining;

     // 서버에 POST 요청을 보내서 업데이트된 데이터를 전달
      var response = await http.post(
        Uri.parse('$BASE_URL/training-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(widget.trainingInfos),  // JSON 형식으로 인코딩된 데이터 전송
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
