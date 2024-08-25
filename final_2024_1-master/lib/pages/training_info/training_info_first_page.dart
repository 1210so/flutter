import 'package:flutter/material.dart';
import 'training_info_second_page.dart';
import 'package:final_2024_1/pages/introduction_info/introduction_info_page.dart';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';

class TrainingInfoFirstPage extends StatefulWidget {
  final int userId;
  final String userName;

  const TrainingInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _TrainingInfoFirstPageState createState() => _TrainingInfoFirstPageState();
}

// TrainingInfoFirstPage의 상태를 관리하는 클래스
class _TrainingInfoFirstPageState extends State<TrainingInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _trainingNameController = TextEditingController();
  bool _isTrainingNameEmpty = false;
  bool _hasInputTrainingName = false;

// 애니메이션을 위한 컨트롤러와 애니메이션 객체들
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _trainingNameController.addListener(_updateTrainingNameTextColor);

// 애니메이션 컨트롤러 초기화
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

// 색상 변화 애니메이션
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.grey,
    ).animate(_fadeController);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        // 애니메이션 완료 후 스크롤
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      });

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.3),
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward().then((_) {
      _slideController.forward();
    });
  }

// 리소스 해제
  @override
  void dispose() {
    _trainingNameController.removeListener(_updateTrainingNameTextColor);
    _trainingNameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

// 훈련명 입력 여부에 따라 텍스트 색상 업데이트
  void _updateTrainingNameTextColor() {
    setState(() {
      _hasInputTrainingName = _trainingNameController.text.isNotEmpty;
    });
  }

 // '다음' 버튼 클릭 시 동작
  void _onNextButtonPressed() {
    setState(() {
      _isTrainingNameEmpty = _trainingNameController.text.isEmpty;
    });

    if (_isTrainingNameEmpty) {
      return;
    }

// 훈련명 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '훈련/교육명 확인',
          infoLabel: '훈련/교육명이',
          info: _trainingNameController.text,
          onConfirmed: () {
          // 확인 후 두 번째 훈련 정보 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainingInfoSecondPage(
                  userId: widget.userId,
                  trainingName: _trainingNameController.text,
                  userName: widget.userName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

// '훈련/교육 없음' 버튼 클릭 시 동작
  void _onNoTrainingButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntroductionInfoPage(
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150),
                  // 슬라이드 애니메이션이 적용된 텍스트
                  SlideTransition(
                    position: _slideAnimation,
                    child: AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Text(
                          "당신이 과거에 참여한\n훈련/교육에 대해\n알고싶어요!\n지원하는 직무와\n관련있는 훈련을\n먼저 작성해주세요",
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
                  // 페이드인 애니메이션이 적용된 위젯들
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                      // 사용자 이름과 질문 텍스트
                        Text(
                          '${widget.userName}님,\n어떤\n훈련/교육명에\n참여하셨나요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        // 훈련명이 비어있을 때 표시되는 에러 메시지
                        if (_isTrainingNameEmpty)
                          Text(
                            '훈련/교육명을 정확히 입력해주세요.',
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
                              controller: _trainingNameController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                color: _hasInputTrainingName ? Color(0xFF001ED6) : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: '훈련/교육명',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 120),
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
                        // '훈련/교육 없음' 버튼
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
                          onPressed: _onNoTrainingButtonPressed,
                          child: const Text(
                            '훈련/교육 없음',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 150), // 스크롤을 위한 추가 공간
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
