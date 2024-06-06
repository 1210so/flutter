import 'package:flutter/material.dart';

class PersonalInfoConfirmationPage extends StatelessWidget {
  final String title;
  final String infoLabel;
  final String info;
  final Function onConfirmed;

  const PersonalInfoConfirmationPage({super.key, required this.title, required this.infoLabel, required this.info, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$infoLabel\n',
                      style: TextStyle(
                        fontSize: 48, // 텍스트 크기
                        color: Colors.black, // 기본 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 굵기
                        fontFamily: 'AppleSDGothicNeoM', // 기본 폰트 설정
                        height: 1.0, // 줄 간격 조정
                      ),
                    ),
                    TextSpan(
                      text: '$info\n',
                      style: TextStyle(
                        fontSize: 48, // 텍스트 크기
                        color: Colors.red, // info 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 굵기
                        fontFamily: 'AppleSDGothicNeoM', // 기본 폰트 설정
                        height: 1.0, // 줄 간격 조정
                      ),
                    ),
                    TextSpan(
                      text: '맞으신가요?',
                      style: TextStyle(
                        fontSize: 48, // 텍스트 크기
                        color: Colors.black, // 기본 텍스트 색상
                        fontWeight: FontWeight.bold, // 텍스트 굵기
                        fontFamily: 'AppleSDGothicNeoM', // 기본 폰트 설정
                        height: 1.0, // 줄 간격 조정
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 버튼 배경색
                      side: BorderSide(color: Color(0xFF001ED6), width: 2), // 버튼 테두리 색상
                      minimumSize: Size(167, 180), // 버튼 최소 크기
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼 모서리 둥글기
                      ),
                      shadowColor: Colors.black, // 버튼 그림자 색상
                      elevation: 5, // 버튼 그림자 높이
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아니오',
                          style: TextStyle(
                            color: Color(0xFF001ED6), // 버튼 텍스트 색상
                            fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                            fontSize: 32, // 버튼 텍스트 크기
                          ),
                        ),
                        SizedBox(height: 25), // 텍스트 사이의 간격
                        Text(
                          '틀렸어요.\n다시 입력할래요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF001ED6),
                            fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(167, 180), // 버튼 최소 크기
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼 모서리 둥글기
                      ),
                      shadowColor: Colors.black, // 버튼 그림자 색상
                      elevation: 5, // 버튼 그림자 높이
                    ),
                    onPressed: () {
                      onConfirmed();
                    },
                    child: const Text(
                      '예',
                      style: TextStyle(
                        color: Colors.white, // 버튼 텍스트 색상
                        fontWeight: FontWeight.bold, // 버튼 텍스트 굵기
                        fontSize: 48, // 버튼 텍스트 크기
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
