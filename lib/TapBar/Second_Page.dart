import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:jaegojochi/db/Stock.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final List<Map<String, dynamic>> _allUsers = [  {"id": 20220620, "name": "202", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31200312, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42388412, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "220", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31239712, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31200312, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42388412, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "220", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31239712, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "10", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "0", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "760", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "810", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "80", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "40", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "560", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "70", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "30", "age": 20},
    {"id": 20220620, "name": "10", "age": 20},
    {"id": 31231243, "name": "50", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "60", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31200312, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42388412, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "220", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31239712, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "202", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31200312, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42388412, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 12312345, "name": "20", "age": 20},
    {"id": 20220620, "name": "220", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31239712, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "210", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "20", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "260", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "10", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "0", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231243, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "205", "age": 20},
    {"id": 20220620, "name": "760", "age": 20},
    {"id": 42341232, "name": "20", "age": 20},
    {"id": 20220620, "name": "810", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "80", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 42341232, "name": "40", "age": 2},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "560", "age": 20},
    {"id": 31231254, "name": "20", "age": 20},
    {"id": 20220620, "name": "230", "age": 20},
    {"id": 20220620, "name": "70", "age": 2},
    {"id": 42341265, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 31231264, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 2},
    {"id": 20220620, "name": "2", "age": 20},
    {"id": 42341254, "name": "20", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "30", "age": 20},
    {"id": 20220620, "name": "10", "age": 20},
    {"id": 31231243, "name": "50", "age": 20},
    {"id": 20220620, "name": "20", "age": 20},
    {"id": 20220620, "name": "60", "age": 20},];

  List<Map<String, dynamic>> _foundUsers = [];

  @override
  initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      List<Stock> selectStock = [];
      final myArrayJson = jsonEncode(selectStock);
      final myArrayDecode = jsonDecode(myArrayJson);
      myArrayDecode[0] = '';
    }

    setState(
      () {
        _foundUsers = results;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // red as border color.
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(" 수 정 일 "),
                Text(" 추 가 "),
                Text(" 소 진 "),
                Text(" 총 량 "),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foundUsers.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(_foundUsers[index]["id"].toString()),
                    Text(_foundUsers[index]['name']),
                    Text(_foundUsers[index]["age"].toString()),
                    Text(_foundUsers[index]["age"].toString()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
