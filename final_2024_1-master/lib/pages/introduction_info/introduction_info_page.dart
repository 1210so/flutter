import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'introduction_info_result_page.dart';
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/config.dart';



class IntroductionInfoPage extends StatefulWidget {
  final int userId;

  const IntroductionInfoPage({super.key, required this.userId});

  @override
  _IntroductionInfoPageState createState() => _IntroductionInfoPageState();
}

class _IntroductionInfoPageState extends State<IntroductionInfoPage> with SingleTickerProviderStateMixin {
  Future<Map<String, dynamic>>? _personalInfoFuture;
  final Set<String> selectedOptions = Set<String>();

  final List<String> options = [
    '책임감이 있는 사람 🫡', '친화력이 있는 사람 👫', '협동심이 있는 사람 🤝', '성실한 사람 🤓', '노력하는 사람 💦',
    '인내심이 있는 사람 ✋', '열정적인 사람 ❤️‍🔥', '끈기 있는 사람 🏃', '도전하는 사람 🔥', '적극적인 사람 🙋', '실행력이 있는 사람 ⚡️',
    '정직한 사람 😇', '리더십 있는 사람 💁', '결단력 있는 사람 🙆', '판단력 있는 사람 ⚖️', '창의적인 사람 🧑‍🎨', '잘 웃는 사람 🤭', '말을 잘 하는 사람 🗣️',
    '친절한 사람 ☺️', '밝은 사람 ✨'
  ];

  late AnimationController _controller;
  late Animation<double> _opacity;
  late List<bool> _visibleOptions;

  @override
  void initState() {
    super.initState();
    _personalInfoFuture = _fetchPersonalInfo();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _opacity = Tween<double>(begin: 1.0, end: 0.3).animate(_controller);
    _visibleOptions = List<bool>.filled(options.length, false);

    _controller.forward().whenComplete(() {
      Future.forEach<int>(List.generate(options.length, (index) => index), (index) {
        return Future.delayed(Duration(milliseconds: 10 * index), () {
          setState(() {
            _visibleOptions[index] = true;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchPersonalInfo() async {
    var response = await http.get(
      Uri.parse('$BASE_URL/personal-info/${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load personal info');
    }
  }

  Future<void> _generateAndSaveIntroduction() async {
    var url = Uri.parse('$BASE_URL/introduction-info/save/${widget.userId}');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'prompt': selectedOptions.join(", ")});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        var responseData = jsonDecode(utf8.decode(response.bodyBytes));
        String introductionText = responseData['gpt'] ?? '자기소개서 생성에 실패했습니다.';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IntroductionInfoResultPage(
              userId: widget.userId,
              introductionText: introductionText,
            ),
          ),
        );
      } else {
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.reasonPhrase}')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _personalInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("자기소개서 생성하기"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("자기소개서 생성하기"),
              ),
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }
          var personalInfo = snapshot.data!;
          var name = personalInfo['name'];

          return Scaffold(
            appBar: AppBar(
              title: const Text("자기소개서 생성하기"),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _opacity.value,
                            child: child,
                          );
                        },
                        child: Text(
                          '$name 선생님을\n설명해주는 표현를\n3개만 골라주세요!',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (_controller.isCompleted) ...[
                        SizedBox(height: 50), // 텍스트와 선택지 사이의 간격
                        Column(
                          children: options.asMap().entries.map((entry) {
                            int index = entry.key;
                            String option = entry.value;
                            return AnimatedOpacity(
                              opacity: _visibleOptions[index] ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 100),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ChoiceChip(
                                  label: Text(option, style: TextStyle(fontSize: 20)), // 글자 크기 키우기
                                  selected: selectedOptions.contains(option),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        if (selectedOptions.length < 3) {
                                          selectedOptions.add(option);
                                        }
                                      } else {
                                        selectedOptions.remove(option);
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: selectedOptions.length == 3 ? _generateAndSaveIntroduction : null,
                          child: const Text('다 골랐어요!', style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("자기소개서 생성하기"),
            ),
            body: Center(
              child: Text('Unexpected state'),
            ),
          );
        }
      },
    );
  }
}
