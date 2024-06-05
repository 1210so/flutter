import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_2024_1/config.dart';

class CareerInfoEditPage extends StatefulWidget {
  final int userId;
  final List<dynamic> careerInfos;
  final int careerIndex;

  const CareerInfoEditPage({super.key,
    required this.userId,
    required this.careerInfos,
    required this.careerIndex});

  @override
  _CareerInfoEditPageState createState() => _CareerInfoEditPageState();
}

class _CareerInfoEditPageState extends State<CareerInfoEditPage> {
  late TextEditingController _placeController;
  late TextEditingController _periodController;
  late TextEditingController _taskController;
  bool _isPlaceEmpty = false;
  bool _isPeriodEmpty = false;
  bool _isTaskEmpty = false;

  @override
  void initState() {
    super.initState();
    var career = widget.careerInfos[widget.careerIndex];
    _placeController = TextEditingController(text: career['place']);
    _periodController = TextEditingController(text: career['period']);
    _taskController = TextEditingController(text: career['task']);
  }

  @override
  void dispose() {
    _placeController.dispose();
    _periodController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _updateData() async {
    setState(() {
      _isPlaceEmpty = _placeController.text.isEmpty;
      _isPeriodEmpty = _periodController.text.isEmpty;
      _isTaskEmpty = _taskController.text.isEmpty;
    });

    if (_isPlaceEmpty || _isPeriodEmpty || _isTaskEmpty) {
      return;
    }

    try {
      var updatedCareer = {
        'place': _placeController.text,
        'period': _periodController.text,
        'task': _taskController.text,
      };
      widget.careerInfos[widget.careerIndex] = updatedCareer;

      var response = await http.post(
        Uri.parse('$BASE_URL/career-info/update/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(widget.careerInfos),
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
            controller: _placeController,
            decoration: InputDecoration(
              labelText: '근무처',
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001ED6),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xFF001ED6), width: 3.0),
              ),
              errorText: _isPlaceEmpty ? '근무처를 입력해주세요' : null,
            ),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _periodController,
            decoration: InputDecoration(
              labelText: '근무 기간',
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001ED6),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: Color(0xFF001ED6), width: 3.0),
              ),
              errorText: _isPeriodEmpty ? '근무 기간을 입력해주세요' : null,
            ),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: '업무 내용',
              labelStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001ED6),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black, width: 3.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Color(0xFF001ED6), width: 3.0),
            ),
            errorText: _isTaskEmpty ? '업무 내용을 입력해주세요' : null,
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
            // 버튼의 그림자 색상
            elevation: 6, // 버튼의 그림자 높이,
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
    ),)
    ,
    );
  }
}
