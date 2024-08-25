import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_2024_1/pages/license_info/license_info_first_page.dart';
import 'package:final_2024_1/config.dart';
import 'career_info_second_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

// 경력 정보 입력의 첫 페이지를 위한 StatefulWidget
class CareerInfoFirstPage extends StatefulWidget {
  final int userId;
  final String userName;

  const CareerInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _CareerInfoFirstPageState createState() => _CareerInfoFirstPageState();
}

class _CareerInfoFirstPageState extends State<CareerInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _placeController = TextEditingController();
  bool _isPlaceEmpty = false;

  // 애니메이션 컨트롤러와 애니메이션 선언
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );


    // 색상 변화 애니메이션 설정
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.grey,
    ).animate(_fadeController);


    // 페이드 인 애니메이션 설정
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));


     // 슬라이드 애니메이션 설정
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.3),
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward().then((_) {
      _slideController.forward();
    });
  }


// '다음' 버튼 눌렀을 때 동작
  void _onNextButtonPressed() {
    setState(() {
      _isPlaceEmpty = _placeController.text.isEmpty;
    });

    if (_isPlaceEmpty) {
      return;
    }

// 입력 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '근무처 확인',
          infoLabel: '근무처가',
          info: _placeController.text,
          onConfirmed: () {
          // 확인 후 다음 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CareerInfoSecondPage(
                  userId: widget.userId,
                  place: _placeController.text,
                  userName: widget.userName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// '경력없음' 버튼 눌렀을 때 동작
  void _onNoExperienceButtonPressed() {
  // 자격증 정보 입력 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LicenseInfoFirstPage(
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
    );
  }

  @override
  void dispose() {
  // 애니메이션 컨트롤러 해제
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    // 화면 터치 시 키보드 닫기
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
                            height: 1.1,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          '${widget.userName}님은\n어디서\n일하셨나요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        // 근무처 입력 필드가 비어있을 때 에러 메시지 표시
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
                        // 근무처 입력 필드
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
                                fontSize: 32,
                                color: Color(0xFF001ED6),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: '근무처',
                                hintStyle: TextStyle(
                                  color: Color(0xFF001ED6),
                                  fontSize: 32,
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
