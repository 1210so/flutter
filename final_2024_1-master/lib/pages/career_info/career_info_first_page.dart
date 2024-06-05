import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_2024_1/pages/license_info/license_info_first_page.dart';
import 'package:final_2024_1/config.dart';
import 'career_info_second_page.dart';
import '../academic_info/academic_info_confirmation_page.dart';

Future<String> getUserName(int userId) async {
  var response = await http.get(
    Uri.parse('$BASE_URL/personal-info/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['name']; // 예시로 사용자의 이름을 반환
  } else {
    throw Exception('사용자 이름을 가져오는데 실패했습니다.');
  }
}

class CareerInfoFirstPage extends StatefulWidget {
  final int userId;

  const CareerInfoFirstPage({super.key, required this.userId});

  @override
  _CareerInfoFirstPageState createState() => _CareerInfoFirstPageState();
}

class _CareerInfoFirstPageState extends State<CareerInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _placeController = TextEditingController();
  bool _isPlaceEmpty = false; // 근무처가 비어 있는지 여부를 확인하는 변수
  String? _userName; // 사용자 이름 변수
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.grey,
    ).animate(_fadeController);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.3),
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward().then((_) {
      _slideController.forward();
    });

    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      String name = await getUserName(widget.userId);
      setState(() {
        _userName = name;
      });
    } catch (e) {
      print('사용자 이름을 가져오는데 실패했습니다: $e');
    }
  }

  void _onNextButtonPressed() {
    setState(() {
      _isPlaceEmpty = _placeController.text.isEmpty;
    });

    if (_isPlaceEmpty || _userName == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademicInfoConfirmationPage(
          title: '근무처 확인',
          infoLabel: '근무처가',
          info: _placeController.text,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CareerInfoSecondPage(
                  userId: widget.userId,
                  place: _placeController.text,
                  userName: _userName!, // 사용자 이름을 전달
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNoExperienceButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LicenseInfoFirstPage(userId: widget.userId),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
                  SizedBox(height: 150),
                  SlideTransition(
                    position: _slideAnimation,
                    child: AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Text(
                          "당신의 과거가 궁금해요!\n 최근 10년 이내의 경력을\n순서대로 작성해주세요!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _colorAnimation.value,
                          ),
                        );
                      },
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        _userName != null
                            ? Text(
                          '${_userName}님은\n어디서\n일하셨나요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Apple SD Gothic Neo',
                            height: 1.2,
                          ),
                        )
                            : CircularProgressIndicator(),
                        // 이름을 불러오는 동안 로딩 인디케이터 표시
                        SizedBox(height: 10),
                        if (_isPlaceEmpty)
                          Text(
                            '근무처를 정확히 입력해주세요.',
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
                              controller: _placeController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF001ED6),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: '근무처',
                                hintStyle: TextStyle(
                                  color: Color(0xFF001ED6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 100),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                            minimumSize: Size(345, 60),
                            shadowColor: Colors.black,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                          onPressed: _onNoExperienceButtonPressed,
                          child: const Text(
                            '경력없음',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
