import 'package:flutter/material.dart';
import 'personal_info_confirmation_page.dart';
import 'personal_info_last_page.dart';

class FifthPage extends StatefulWidget {
  final String name;
  final String birth;
  final String ssn;
  final String contact;

  const FifthPage({
    super.key,
    required this.name,
    required this.birth,
    required this.ssn,
    required this.contact,
  });

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  bool _isEmailEmpty = false;
  bool _hasInputEmail = false;
  bool _hasInputDomain = false;
  final List<String> _emailDomains = [
    'naver.com',
    'gmail.com',
    'hanmail.net',
    'daum.net',
    'yahoo.com',
    'hotmail.com',
    'outlook.com',
    'kakao.com',
    'nate.com',
    'icloud.com',
  ];

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateEmailTextColor);
    _domainController.addListener(_updateDomainTextColor);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateEmailTextColor);
    _domainController.removeListener(_updateDomainTextColor);
    _emailController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _updateEmailTextColor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasInputEmail = _emailController.text.isNotEmpty;
      });
    });
  }

  void _updateDomainTextColor() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _hasInputDomain = _domainController.text.isNotEmpty;
      });
    });
  }

  void _onNextButtonPressed() {
    setState(() {
      _isEmailEmpty = _emailController.text.isEmpty || _domainController.text.isEmpty;
    });

    if (_isEmailEmpty) {
      return;
    }

    String email = '${_emailController.text}@${_domainController.text}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonalInfoConfirmationPage(
          title: '이메일 주소 확인',
          infoLabel: '이메일 주소가',
          info: email,
          onConfirmed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LastPage(
                  name: widget.name,
                  birth: widget.birth,
                  ssn: widget.ssn,
                  contact: widget.contact,
                  email: email,
                ),
              ),
            );
          },
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
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 230), // 텍스트와 입력 칸을 상단에 고정
                  Text(
                    '${widget.name}님의\n이메일 주소를\n입력해주세요',
                    textAlign: TextAlign.center, // 텍스트 가운데 정렬
                    style: TextStyle(
                      fontSize: 48, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                      height: 1.0, // 줄 간격 조정 (기본값은 1.0, 더 작은 값을 사용하여 줄 간격 좁히기)
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_isEmailEmpty)
                    Text(
                      '이메일 주소를 정확히 입력해주세요.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160, // 입력 창의 너비
                        height: 60, // 입력 창의 높이
                        decoration: BoxDecoration(
                          color: Colors.white, // 입력 창의 배경색
                          borderRadius: BorderRadius.circular(24.0), // 입력 창의 모서리 둥글기
                          border: Border.all(
                            color: Color(0xFF001ED6), // 입력 창의 테두리 색상
                            width: 2.0, // 입력 창의 테두리 두께
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0), // 입력 창의 내부 패딩
                          child: TextField(
                            controller: _emailController, // 입력 컨트롤러 설정
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25, // 입력 텍스트의 크기
                              color: _hasInputEmail ? Color(0xFF001ED6) : Colors.grey, // 입력 텍스트의 색상
                              fontWeight: FontWeight.bold, // 입력 텍스트의 굵기
                            ),
                            decoration: InputDecoration(
                              hintText: '아이디', // 입력 필드의 힌트 텍스트
                              hintStyle: TextStyle(
                                color: Colors.grey, // 힌트 텍스트의 색상
                                fontSize: 25, // 힌트 텍스트의 크기
                                fontWeight: FontWeight.bold, // 힌트 텍스트의 굵기
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: -15), // 수직으로 가운데 정렬
                              border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '@',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF001ED6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 160, // 도메인 선택 창의 너비
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
                          child: Autocomplete<String>(
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              } else {
                                return _emailDomains.where((String option) {
                                  return option.contains(textEditingValue.text.toLowerCase());
                                });
                              }
                            },
                            onSelected: (String selection) {
                              setState(() {
                                _domainController.text = selection;
                                _hasInputDomain = true;
                              });
                            },
                            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                              _domainController.text = textEditingController.text;
                              return TextField(
                                controller: textEditingController,
                                textAlign: TextAlign.center,
                                focusNode: focusNode,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: textEditingController.text.isNotEmpty ? Color(0xFF001ED6) : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: '도메인 선택',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: -15), // 수직으로 가운데 정렬
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    _hasInputDomain = text.isNotEmpty;
                                  });
                                },
                              );
                            },
                            optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    side: BorderSide(color: Color(0xFF001ED6)), // 파란색 테두리
                                  ),
                                  child: Container(
                                    width: 140,
                                    color: Colors.white, // 흰색 배경
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(8.0),
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final String option = options.elementAt(index);
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                option,
                                                style: TextStyle(
                                                  color: Color(0xFF001ED6), // 파란 글자색
                                                  fontSize: 18,
                                                ),
                                              ),
                                              onTap: () {
                                                onSelected(option);
                                              },
                                            ),
                                            if (index != options.length - 1) // 마지막 항목이 아닌 경우에만 파란 줄 추가
                                              Divider(
                                                color: Color(0xFF001ED6), // 파란색 줄
                                                thickness: 1,
                                                height: 1,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 150),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001ED6), // 버튼의 배경색
                      side: BorderSide(color: Color(0xFFFFFFFF), width: 2,), // 버튼의 테두리 설정
                      minimumSize: Size(345, 60), // 버튼의 최소 크기 설정
                      shadowColor: Colors.black, // 버튼의 그림자 색상
                      elevation: 6, // 버튼의 그림자 높이,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0), // 버튼의 모서리 둥글기
                      ),
                    ),
                    onPressed: _onNextButtonPressed, // 다음 버튼을 눌렀을 때 실행되는 함수
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 18, // 버튼 텍스트의 크기
                        fontWeight: FontWeight.bold, // 버튼 텍스트의 굵기
                        color: Colors.white, // 버튼 텍스트의 색상
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // 추가된 공간
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
