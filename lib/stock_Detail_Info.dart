import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jaegojochi/TapBar/First_Page.dart';
import 'package:jaegojochi/TapBar/Second_Page.dart';
import 'package:jaegojochi/db/DatabaseHelper.dart';

import 'TapBar/First_Page.dart';
import 'TapBar/Second_Page.dart';
import 'db/Stock.dart';
import 'main.dart';

class stock_Detail_Info extends StatefulWidget {
  final String name;

  const stock_Detail_Info({Key? key, required this.name}) : super(key: key);

  @override
  State<stock_Detail_Info> createState() => _stock_Detail_InfoState();
}

class _stock_Detail_InfoState extends State<stock_Detail_Info> {

  List<Stock> selectStock = [];




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('상세페이지'),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Text("삭제"),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[Text("정말 삭제하시겠습니까?")],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("취소"),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                ),
                                onPressed: () {
                                  DatabaseHelper.instance.delete(widget.name);
                                  DatabaseHelper.instance.deleteLog(widget.name);
                                  Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const mainPage()),
                                      (route) => false);
                                },
                                child: const Text("확인"),
                              ),
                            ],
                          );
                        });
                    //DatabaseHelper.instance.delete(widget.name);
                  },
                  icon: const Icon(Icons.delete))
            ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text('1'),
                ),
                Tab(
                  child: Text('2'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              FirstPage(name: widget.name.toString()),
              Center(
                child: SecondPage(name: widget.name.toString()),
              ),
            ],
          ),
        ));
  }
}
