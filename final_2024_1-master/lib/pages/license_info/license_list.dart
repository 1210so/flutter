import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('자격증 목록'),
        ),
        body: Center(
          child: DropdownMenu(),
        ),
      ),
    );
  }
}

class DropdownMenu extends StatefulWidget {
  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
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
          // 빈 문자열 제거
          _items.removeWhere((item) => item.isEmpty);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedItem,
      items: _items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
          print(_selectedItem);
        });
      },
    );
  }
}
