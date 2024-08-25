import 'package:flutter/material.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_first_page.dart';

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> with TickerProviderStateMixin {
  // 페이지의 여러 애니메이션을 위한 애니메이션 컨트롤러들
  late AnimationController _initialFadeController;
  late AnimationController _loginFadeController;
  late AnimationController _loginSlideController;

  // 페이드 및 슬라이드 효과를 위한 애니메이션들
  late Animation<double> _initialFadeAnimation;
  late Animation<double> _loginFadeAnimation;
  late Animation<Offset> _loginSlideAnimation;

  // 색상 전환 애니메이션
  late Animation<Color?> _colorAnimation;

  // 로그인 섹션의 가시성을 제어하는 변수
  bool _showLoginSection = false;

  @override
  void initState() {
    super.initState();

// 애니메이션 컨트롤러들을 초기화하고 각 애니메이션의 지속 시간을 설정
    _initialFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _loginFadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _loginSlideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

// 초기 색상 애니메이션 설정 (검정색에서 회색으로 변환)
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.grey,
    ).animate(_initialFadeController);


// 초기 페이드 애니메이션 설정 (불투명도 0에서 1로 변화)
    _initialFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _initialFadeController, curve: Curves.easeIn))
      ..addStatusListener((status) {
      // 애니메이션이 완료되면 로그인 섹션을 보여줌
        if (status == AnimationStatus.completed) {
          setState(() {
            _showLoginSection = true;
          });
          _loginFadeController.forward();
          _loginSlideController.forward();
        }
      });

// 로그인 섹션의 페이드 애니메이션 설정
    _loginFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _loginFadeController, curve: Curves.easeIn));


// 로그인 섹션의 슬라이드 애니메이션 설정 (아래에서 위로 이동)
    _loginSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset(0, 0.3),
    ).animate(CurvedAnimation(parent: _loginSlideController, curve: Curves.easeIn));


// 초기 페이드 애니메이션 시작
    _initialFadeController.forward();
  }

  @override
  void dispose() {
   // 애니메이션 컨트롤러 해제 (리소스 정리)
    _initialFadeController.dispose();
    _loginFadeController.dispose();
    _loginSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        // 페이지 상단의 텍스트 위치
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
          // 로그인 섹션을 위한 스크롤 가능한 영역
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 150),
                    // 슬라이드 애니메이션 적용된 텍스트
                    SlideTransition(
                      position: _loginSlideAnimation,
                      child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _initialFadeAnimation,
                            child: Text(
                              '처음이시군요!\n반가워요 ✋',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: _colorAnimation.value,
                                fontFamily: 'AppleSDGothicNeoM',
                                height: 1.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                    if (_showLoginSection) // _showLoginSection이 true일 때만 표시
                      FadeTransition(
                        opacity: _loginFadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              '회원가입\n하시겠습니까?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'AppleSDGothicNeoM',
                                height: 1.0,
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FirstPage()),
                                    );
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
                                        '바로\n이력서 생성할래요.',
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
                                    // Add your onPressed function here for login
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
