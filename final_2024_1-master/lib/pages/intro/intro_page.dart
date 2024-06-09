import 'package:flutter/material.dart';
import 'intro_page2.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with TickerProviderStateMixin {
  late AnimationController _helloFadeController;
  late AnimationController _helloSlideController;
  late AnimationController _secondFadeController;
  late AnimationController _secondSlideController;
  late Animation<double> _helloFadeAnimation;
  late Animation<Offset> _helloSlideAnimation;
  late Animation<double> _secondFadeAnimation;
  late Animation<Offset> _secondSlideAnimation;
  bool _showSecondSection = false;

  @override
  void initState() {
    super.initState();

    _helloFadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _helloSlideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _secondFadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _secondSlideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _helloFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _helloFadeController, curve: Curves.easeIn));

    _helloSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1.5),
    ).animate(CurvedAnimation(parent: _helloSlideController, curve: Curves.easeIn));

    _secondFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _secondFadeController, curve: Curves.easeIn));

    _secondSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset(0, 0.0),
    ).animate(CurvedAnimation(parent: _secondSlideController, curve: Curves.easeIn));

    _helloFadeController.forward().then((_) {
      setState(() {
        _showSecondSection = true;
      });
      _secondFadeController.forward();
      _secondSlideController.forward();
      _helloSlideController.forward();
    });
  }

  @override
  void dispose() {
    _helloFadeController.dispose();
    _helloSlideController.dispose();
    _secondFadeController.dispose();
    _secondSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _helloFadeAnimation,
              child: SlideTransition(
                position: _helloSlideAnimation,
                child: Text(
                  '안녕하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AppleSDGothicNeoM',
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showSecondSection)
                    FadeTransition(
                      opacity: _secondFadeAnimation,
                      child: SlideTransition(
                        position: _secondSlideAnimation,
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
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
                                    // "아니오" 버튼을 눌러도 아무 동작하지 않음
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
            ),
          ),
        ],
      ),
    );
  }
}
