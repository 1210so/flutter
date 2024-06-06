import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_2024_1/pages/personal_info/personal_info_confirmation_page.dart';
import 'license_info_second_page.dart';
import 'package:final_2024_1/pages/training_info/training_info_first_page.dart';
import 'package:final_2024_1/config.dart';

class LicenseInfoFirstPage extends StatefulWidget {
  final int userId;
  final String userName;
  const LicenseInfoFirstPage({super.key, required this.userId, required this.userName});

  @override
  _LicenseInfoFirstPageState createState() => _LicenseInfoFirstPageState();
}

class _LicenseInfoFirstPageState extends State<LicenseInfoFirstPage> with TickerProviderStateMixin {
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> _items = [];
  String? _selectedItem;
  bool _isLoading = true;
  bool _isLicenseNameEmpty = false;
  bool _hasInputLicenseName = false;
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

    // 로딩창을 띄우고 데이터를 가져옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLoadingDialog();
      fetchData();
    });
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

  void _showLoadingDialog() {
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
          _items.removeWhere((item) => item.isEmpty);

          if (_items.isNotEmpty) {
            _selectedItem = _items[0];
          }
          _isLoading = false;
        });
        Navigator.of(context).pop();
        _fadeController.forward().then((_) {
          _slideController.forward();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void _onNextButtonPressed() {
    setState(() {
      _isLicenseNameEmpty = _typeAheadController.text.isEmpty;
    });

    if (_isLicenseNameEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '자격증/면허명 확인',
          infoLabel: '자격증/면허명이',
          info: _typeAheadController.text,
          onConfirmed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LicenseInfoSecondPage(
                  userId: widget.userId,
                  licenseName: _typeAheadController.text,
                  userName: widget.userName,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNoLicenseButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainingInfoFirstPage(
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
