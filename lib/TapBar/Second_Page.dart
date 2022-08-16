import 'package:flutter/material.dart';
import 'package:jaegojochi/db/Log.dart';
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
  List<LogData> reversedLogData = [];

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
        reversedLogData = List.from(logData.reversed);
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
              itemCount: reversedLogData.length,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.height*0.111,
                      child: Text(
                        reversedLogData[index].date.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.height*0.111,
                      child: Text(
                        reversedLogData[index].up.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.height*0.111,
                      child: Text(
                        reversedLogData[index].down.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.height*0.111,
                      child: Text(
                        reversedLogData[index].total.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
