import 'package:flutter/material.dart';
import 'intro_page2.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 16,
            top: 60,
            child: Text(
              '12쉽소',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF001ED6),
                fontFamily: 'HakgyoansimKkwabaegiR',
              ),
            ),
          ),
          Center(
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
                          text: '안녕하세요.\n',
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppleSDGothicNeoM',
                            height: 1.0,
                          ),
                        ),
                        TextSpan(
                          text: '12쉽소',
                          style: TextStyle(
                            fontSize: 55,
                            color: Color(0xFF001ED6),
                            fontFamily: 'HakgyoansimKkwabaegiR',
                            height: 1.0,
                          ),
                        ),
                        TextSpan(
                          text: '를\n처음 사용하시나요?',
                          style: TextStyle(
                            fontSize: 48,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AppleSDGothicNeoM',
                            height: 1.0,
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
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF001ED6), width: 2),
                          minimumSize: Size(167, 180),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          shadowColor: Colors.black,
                          elevation: 5,
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
                                color: Color(0xFF001ED6),
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            SizedBox(height: 25),
                            Text(
                              '틀렸어요.\n다시 입력할래요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF001ED6),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF001ED6),
                          side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                          minimumSize: Size(167, 180),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          shadowColor: Colors.black,
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IntroPage2()),
                          );
                        },
                        child: Text(
                          '예',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
