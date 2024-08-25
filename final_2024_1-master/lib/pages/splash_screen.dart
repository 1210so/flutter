import 'package:final_2024_1/pages/intro/intro_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:final_2024_1/pages/personal_info/personal_info_first_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      );
    });
  }

  // 1210so 로딩 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001ED6), // 배경색 설정
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '12쉽소',
              style: TextStyle(
                fontSize: 128,
                color: Colors.white,
                fontFamily: 'HakgyoansimKkwabaegiR',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
