import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'license_info_second_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_first_page.dart';
import 'package:final_2024_1/config.dart';

Future<String> getUserName(int userId) async {
  var response = await http.get(
    Uri.parse('$BASE_URL/personal-info/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['name'];
  } else {
    throw Exception('사용자 이름을 가져오는데 실패했습니다.');
  }
}

class LicenseInfoFirstPage extends StatefulWidget {
  final int userId;
  const LicenseInfoFirstPage({super.key, required this.userId});

  @override
  _LicenseInfoFirstPageState createState() => _LicenseInfoFirstPageState();
}

class _LicenseInfoFirstPageState extends State<LicenseInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> _items = [];
  String? _selectedItem;
  bool _isLoading = false;
  bool _isLicenseNameEmpty = false;
  bool _hasInputLicenseName = false;
  String? _userName;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _typeAheadController.addListener(_updateLicenseNameTextColor);

    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
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

    _fetchUserName();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _typeAheadController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _items.isEmpty) {
      _showLoadingDialog();
      fetchData();
    }
  }

  void _updateLicenseNameTextColor() {
    setState(() {
      _hasInputLicenseName = _typeAheadController.text.isNotEmpty;
    });
  }

  Future<void> _fetchUserName() async {
    try {
      String name = await getUserName(widget.userId);
      setState(() {
        _userName = name;
      });
    } catch (e) {
      print('사용자 이름을 가져오는데 실패했습니다: $e');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xFF001ED6), // 로딩 스피너의 배경색
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // 로딩 스피너의 색상
                ),
                SizedBox(width: 20),
                Text(
                  "데이터를 불러오는 중입니다",
                  style: TextStyle(
                    fontSize: 18, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                    color: Color(0xFF001ED6), // 텍스트 색상
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white, // 다이얼로그 배경색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0), // 다이얼로그 모서리 둥글기
            side: BorderSide(color: Color(0xFF001ED6), width: 2), // 다이얼로그 테두리 설정
          ),
        );
      },
    );
  }

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
          _items = [
            ...dataList1.map((item) => item['종목명']?.toString() ?? ''),
            ...dataList2.map((item) => item['자격명']?.toString() ?? '')
          ];
          _items.removeWhere((item) => item.isEmpty); // 빈 문자열 제거

          // 초기 선택 항목 설정
          if (_items.isNotEmpty) {
            _selectedItem = _items[0];
          }
          _isLoading = false; // 데이터 로딩 완료
        });
        Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false; // 데이터 로딩 실패 시에도 로딩 상태 해제
      });
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
    }
  }

  void _onNextButtonPressed() {
    setState(() {
      _isLicenseNameEmpty = _typeAheadController.text.isEmpty;
    });

    if (_isLicenseNameEmpty) {
      return;
    }

    if (_selectedItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LicenseInfoSecondPage(
            userId: widget.userId,
            licenseName: _selectedItem!,
          ),
        ),
      );
    }
  }

  void _onNoLicenseButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingInfoFirstPage(userId: widget.userId),
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
                          _userName != null
                              ? "${_userName}님이 보유하신\n자격증/면허가 궁금해요!\n지원하는 직무와\n관련있는 것부터 먼저\n작성해주세요!"
                              : '',
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
                        _userName != null
                            ? Text(
                          '${_userName}님은\n어떤 자격증/면허를\n가지고 계신가요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Apple SD Gothic Neo',
                            height: 1.2,
                          ),
                        )
                            : CircularProgressIndicator(),
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
                                  fontSize: 20,
                                  color: _hasInputLicenseName ? Color(0xFF001ED6) : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: '자격증/면허명',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
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
                                color: Colors.white, // 리스트의 배경색을 흰색으로 설정
                              ),
                              suggestionsCallback: (pattern) {
                                return _items.where((item) => item.toLowerCase().contains(pattern.toLowerCase()));
                              },
                              itemBuilder: (context, String suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF001ED6),),
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
                                  child: Text('No items found'),
                                ),
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
