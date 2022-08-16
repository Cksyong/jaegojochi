import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jaegojochi/db/DetailDBHelper.dart';
import 'package:jaegojochi/db/Log.dart';
import 'package:jaegojochi/db/Stock.dart';

import '../db/DatabaseHelper.dart';

class SecondPage extends StatefulWidget {
  final String name;

  const SecondPage({Key? key, required this.name}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> {

  @override
  List<LogData> logData = [];

  void initState() {
    super.initState();
    logData = [];
    refreshlist(widget.name);
  }

  refreshlist(String name) {
    DatabaseHelper.instance.getStocksLog(name).then((name) {
      setState(() {
        logData.clear();
        logData.addAll(name);
      });
    });
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
              itemCount: logData.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.height*0.111,
                        child: Text(logData[index].date.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                             ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.height*0.069,
                        child: Text(logData[index].up.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.height*0.059,
                        child: Text(logData[index].down.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.height*0.080,
                        child: Text(logData[index].total.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        )),
                    // Text('data'),
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
