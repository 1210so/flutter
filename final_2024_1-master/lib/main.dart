import 'package:flutter/material.dart';
// import 'package:final_2024_1/pages/personal_info/personal_info_first_page.dart';
import 'package:final_2024_1/pages/splash_screen.dart'; // 스플래시 스크린 파일을 임포트
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '사용자 정보 수집 앱',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primarySwatch: Colors.indigo,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        fontFamily: 'AppleSDGothicNeoM', // 기본 폰트 설정
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'), // 한국어 로케일 지원
      ],
      locale: const Locale('ko', 'KR'), // 기본 로케일 설정
      home: SplashScreen(), // 첫 화면으로 스플래시 스크린 설정
    );
  }
}
