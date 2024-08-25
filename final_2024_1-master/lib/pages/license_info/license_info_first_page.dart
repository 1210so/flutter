import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'license_info_second_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_first_page.dart';
// import 'package:final_2024_1/config.dart';

class LicenseInfoFirstPage extends StatefulWidget {
  final int userId; // 사용자 ID
  final String userName; // 사용자 이름

  // 생성자
  const LicenseInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _LicenseInfoFirstPageState createState() => _LicenseInfoFirstPageState();
}

class _LicenseInfoFirstPageState extends State<LicenseInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _typeAheadController = TextEditingController(); // 자격증/면허명 입력 컨트롤러
  List<String> _items = []; // 자격증/면허명 목록
  String? _selectedItem; // 선택된 자격증/면허명
  bool _isLoading = true; // 데이터 로딩 상태 플래그
  bool _isLicenseNameEmpty = false; // 자격증/면허명 입력 여부 플래그
  bool _hasInputLicenseName = false; // 자격증/면허명 입력 여부 플래그
  late AnimationController _fadeController; // 페이드 애니메이션 컨트롤러
  late AnimationController _slideController; // 슬라이드 애니메이션 컨트롤러
  late Animation<Color?> _colorAnimation; // 색상 애니메이션
  late Animation<double> _fadeAnimation; // 페이드 애니메이션
  late Animation<Offset> _slideAnimation; // 슬라이드 애니메이션
  late FocusNode _focusNode; // 포커스 노드
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러

  @override
  void initState() {
    super.initState();

    // 포커스 노드 초기화 및 포커스 변화 리스너 추가
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    // 텍스트 컨트롤러 리스너 추가
    _typeAheadController.addListener(_updateLicenseNameTextColor);

    // 페이드 애니메이션 컨트롤러 초기화
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 슬라이드 애니메이션 컨트롤러 초기화
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // 색상 애니메이션 초기화
    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.grey,
    ).animate(_fadeController);

    // 페이드 애니메이션 초기화
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 페이드 애니메이션 완료 후 스크롤을 가장 아래로 이동
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      });

    // 슬라이드 애니메이션 초기화
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -0.3),
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // 화면 렌더링 후 데이터 로딩 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
      fetchData();
    });
  }

  @override
  void dispose() {
    // 사용한 리소스 해제
    _focusNode.dispose();
    _typeAheadController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // 포커스가 변경되었을 때 데이터가 없으면 로딩 다이얼로그와 함께 데이터 가져오기
    if (_focusNode.hasFocus && _items.isEmpty) {
      _showLoadingDialog();
      fetchData();
    }
  }

  void _updateLicenseNameTextColor() {
    // 자격증/면허명 입력 여부에 따라 텍스트 색상 변경
    setState(() {
      _hasInputLicenseName = _typeAheadController.text.isNotEmpty;
    });
  }

  void _showLoadingDialog() {
    // 데이터 로딩 중 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Color(0xFF001ED6),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "자격증/면허 정보를\n불러오는 중입니다",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001ED6),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(color: Color(0xFF001ED6), width: 2),
            ),
          ),
        );
      },
    );
  }

  // API에서 자격증/면허 데이터를 가져오고 상태 업데이트
  Future<void> fetchData() async {
    try {
      final response1 = await http.get(Uri.parse(
          'https://api.odcloud.kr/api/15082998/v1/uddi:950a6280-b56a-417e-b97c-de941adbfc9f?page=1&perPage=600&serviceKey=w%2BpW2nlhBLeFBdWYtKoiZ8sA2lNwr3LBToOZWQsIE7ota7%2BXIGvs52ovvgSdhgIoMysR%2FwwR9hSxEexkAX6fQA%3D%3D'));
      final response2 = await http.get(Uri.parse(
          'https://api.odcloud.kr/api/15075600/v1/uddi:e7beeff5-beb1-419e-9393-d6bb29f86d5e?page=1&perPage=68645&serviceKey=w%2BpW2nlhBLeFBdWYtKoiZ8sA2lNwr3LBToOZWQsIE7ota7%2BXIGvs52ovvgSdhgIoMysR%2FwwR9hSxEexkAX6fQA%3D%3D'));

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final Map<String, dynamic> jsonData1 = jsonDecode(response1.body);
        final Map<String, dynamic> jsonData2 = jsonDecode(response2.body);

        final List<dynamic> dataList1 = jsonData1['data'] ?? [];
        final List<dynamic> dataList2 = jsonData2['data'] ?? [];

        setState(() {
          // 두 API에서 가져온 자격증/면허명 데이터 결합
          _items = [
            ...dataList1.map((item) => item['종목명']?.toString() ?? ''),
            ...dataList2.map((item) => item['자격명']?.toString() ?? '')
          ];
          _items.removeWhere((item) => item.isEmpty);

          if (_items.isNotEmpty) {
            _selectedItem = _items[0];
          }
          _isLoading = false;
        });
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
        _fadeController.forward().then((_) {
          _slideController.forward(); // 페이드 애니메이션 완료 후 슬라이드 애니메이션 시작
        });
      } else {
        throw Exception('데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print("데이터 가져오기 오류: $e");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop(); // 오류 발생 시 로딩 다이얼로그 닫기
    }
  }

  void _onNextButtonPressed() {
    setState(() {
      // 자격증/면허명이 입력되지 않은 경우 상태 플래그 설정
      _isLicenseNameEmpty = _typeAheadController.text.isEmpty;
    });

    if (_isLicenseNameEmpty) {
      // 자격증/면허명이 입력되지 않았으면 함수 종료
      return;
    }

    // 자격증/면허명이 입력된 경우 확인 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '자격증/면허명 확인', // 확인 페이지 제목
          infoLabel: '자격증/면허명이', // 정보 레이블
          info: _typeAheadController.text, // 입력된 자격증/면허명
          onConfirmed: () {
            // 확인 버튼이 눌렸을 때 다음 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LicenseInfoSecondPage(
                  userId: widget.userId, // 사용자 ID
                  licenseName: _typeAheadController.text, // 자격증/면허명
                  userName: widget.userName, // 사용자 이름
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNoLicenseButtonPressed() {
    // 자격증/면허명이 없는 경우 교육 정보 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingInfoFirstPage(
          userId: widget.userId, // 사용자 ID
          userName: widget.userName, // 사용자 이름
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
        body: _isLoading
            ? SizedBox.shrink() // 로딩 중에는 아무것도 표시하지 않음
            : SingleChildScrollView(
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
                          "당신이 보유하고 있는\n자격증/면허가 궁금해요!\n지원하는 직무와\n관련있는 것부터 먼저\n작성해주세요!",
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
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          '${widget.userName}님은\n어떤 자격증/면허를\n가지고 계신가요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (_isLicenseNameEmpty)
                          Text(
                            '자격증/면허명을 정확히 입력해주세요.',
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
                            child: TypeAheadFormField(
                              textFieldConfiguration: TextFieldConfiguration(
                                focusNode: _focusNode,
                                controller: _typeAheadController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  color: _hasInputLicenseName ? Color(0xFF001ED6) : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: '자격증/면허명',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                constraints: BoxConstraints(
                                  maxHeight: 200,
                                ),
                                hasScrollbar: true,
                                color: Colors.white,
                              ),
                              suggestionsCallback: (pattern) {
                                return _items.where((item) => item.toLowerCase().contains(pattern.toLowerCase()));
                              },
                              itemBuilder: (context, String suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF001ED6),
                                    ),
                                  ),
                                );
                              },
                              onSuggestionSelected: (String suggestion) {
                                _typeAheadController.text = suggestion;
                                setState(() {
                                  _selectedItem = suggestion;
                                });
                              },
                              noItemsFoundBuilder: (context) => const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text('자격증/면허 정보가 없습니다.\n직접 입력해주세요.'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 130),
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
                          onPressed: _onNoLicenseButtonPressed,
                          child: const Text(
                            '자격증/면허 없음',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 150),
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
