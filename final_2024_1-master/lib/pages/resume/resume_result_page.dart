import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart'; // for sharing functionality
import 'package:http/http.dart' as http; // for HTTP requests
import 'package:url_launcher/url_launcher.dart'; // for URL launching
import 'package:final_2024_1/config.dart';
import 'package:final_2024_1/pages/intro/intro_page.dart';
import 'package:flutter/services.dart'; // for Clipboard

class ResumeResultPage extends StatelessWidget {
  final String url;
  final int userId;

  const ResumeResultPage({Key? key, required this.url, required this.userId}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch url";
    }
  }

  Future<void> _shareResume(BuildContext context) async {
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
                  backgroundColor: Color(0xFF001ED6),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(width: 20),
                Text(
                  "출력 준비중입니다.\n잠시 기다려주세요!",
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
        );
      },
    );

    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/resume/$userId/uploadPdf'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String fileUrl = response.body;
        await Future.delayed(Duration(seconds: 50));
        Navigator.of(context).pop();
        await _launchURL(fileUrl);
      } else {
        Navigator.of(context).pop();
        throw Exception('파일 업로드 실패: ${response.body}');
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF001ED6)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IntroPage(),
              ),
            );
          },
        ),
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IntroPage(),
              ),
            );
          },
          child: Text(
            '메인 화면으로',
            style: TextStyle(
                color: Color(0xFF001ED6),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF001ED6),
                side: BorderSide(color: Color(0xFFFFFFFF), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                shadowColor: Colors.black,
                elevation: 6,
              ),
              onPressed: () => _showShareOptions(context, url),
              child: Text(
                '공유하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  void _showShareOptions(BuildContext context, String url) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF001ED6), Color(0xFF2341FE)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // ShareOptions 창 닫기
                        _showShareDialog(context, url);
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '공유하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '카카오톡, 문자 메세지, 이메일로\n지금 만든 이력서 공유하기',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1AA64A), Color(0xFF2A6742)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: InkWell(
                      onTap: () {
                        _shareResume(context);
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '출력하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '만들어진 이력서를\n출력할 수 있는 pdf 파일 다운로드',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showShareDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // 배경 색을 하얀색으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: Color(0xFF001ED6), width: 3), // 테두리를 파란색으로 설정
          ),
          title: Text('공유하기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildShareIconButtonWithImage(context, '카카오톡', 'assets/kakao.png', url),
                  _buildShareIconButton(context, '문자 메세지', Icons.message, url),
                  _buildShareIconButton(context, '이메일', Icons.email, url),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '공유할 링크',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('URL이 클립보드에 복사되었습니다.')),
                      );
                    },
                  ),
                ),
                controller: TextEditingController(text: url),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildShareIconButton(BuildContext context, String label, IconData icon, String url) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: () {
            Share.share(url);
            Navigator.of(context).pop(); // 공유 창 닫기
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildShareIconButtonWithImage(BuildContext context, String label, String assetPath, String url) {
    return Column(
      children: [
        IconButton(
          icon: Image.asset(assetPath, width: 40, height: 40),
          onPressed: () {
            Share.share(url);
            Navigator.of(context).pop(); // 공유 창 닫기
          },
        ),
        Text(label),
      ],
    );
  }
}
