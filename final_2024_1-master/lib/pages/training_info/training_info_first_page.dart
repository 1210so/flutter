import 'package:flutter/material.dart';
import 'training_info_second_page.dart';
import 'package:final_2024_1/pages/introduction_info/introduction_info_page.dart';
import '../academic_info/academic_info_confirmation_page.dart';

class TrainingInfoFirstPage extends StatefulWidget {
  final int userId;
  final String userName;

  const TrainingInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _TrainingInfoFirstPageState createState() => _TrainingInfoFirstPageState();
}

class _TrainingInfoFirstPageState extends State<TrainingInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _trainingNameController = TextEditingController();
  bool _isTrainingNameEmpty = false;
  bool _hasInputTrainingName = false;

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

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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

  @override
  void dispose() {
    _trainingNameController.removeListener(_updateTrainingNameTextColor);
    _trainingNameController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTrainingNameTextColor() {
    setState(() {
      _hasInputTrainingName = _trainingNameController.text.isNotEmpty;
    });
  }

  void _onNextButtonPressed() {
    setState(() {
      _isTrainingNameEmpty = _trainingNameController.text.isEmpty;
    });

    if (_isTrainingNameEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcademicInfoConfirmationPage(
          title: '훈련/교육명 확인',
          infoLabel: '훈련/교육명이',
          info: _trainingNameController.text,
          onConfirmed: () {
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
                          ),
                        );
                      },
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          '${widget.userName}님,\n어떤\n훈련/교육명에\n참여하셨나요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Apple SD Gothic Neo',
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 10),
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
                                fontSize: 20,
                                color: _hasInputTrainingName ? Color(0xFF001ED6) : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: '훈련/교육명',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
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
