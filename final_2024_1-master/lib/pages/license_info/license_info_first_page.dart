import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'license_info_second_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LicenseInfoFirstPage extends StatefulWidget {
  final int userId;
  const LicenseInfoFirstPage({super.key, required this.userId});

  @override
  _LicenseInfoFirstPageState createState() => _LicenseInfoFirstPageState();
}

class _LicenseInfoFirstPageState extends State<LicenseInfoFirstPage> {
  final TextEditingController _licenseNameController = TextEditingController();
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> _items = [];
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    fetchData();
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
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _submitData() async {
    if (_selectedItem == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:50369/license-info/save/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'licenseName': _selectedItem!,
          // 필요한 경우 추가 필드를 여기에 넣을 수 있습니다.
        }),
      );

      if (response.statusCode == 201) {
        print('Data submitted successfully');
      } else {
        throw Exception('Failed to submit data');
      }
    } catch (e) {
      print("Error submitting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("자격증/면허 입력"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _licenseNameController,
                decoration: const InputDecoration(
                  labelText: '가지고 계신 자격증이나 면허를 입력해주세요',
                ),
              ),
              SizedBox(height: 30),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: const InputDecoration(
                    labelText: '가지고 계신 자격증이나 면허를 입력해주세요',
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _items.where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
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
              ElevatedButton(
                onPressed: _items.isEmpty ? null : _submitData,
                child: Text('제출'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LicenseInfoSecondPage(
                      userId: widget.userId,
                      licenseName: _licenseNameController.text)));
        },
        tooltip: '다음',
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
