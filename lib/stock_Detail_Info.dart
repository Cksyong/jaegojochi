import 'package:flutter/material.dart';
import 'package:jaegojochi/TapBar/First_Page.dart';
import 'package:jaegojochi/TapBar/Second_Page.dart';
import 'package:jaegojochi/db/DatabaseHelper.dart';

import 'TapBar/First_Page.dart';
import 'TapBar/Second_Page.dart';
import 'db/Stock.dart';

class stock_Detail_Info extends StatefulWidget {
  final String name;

  const stock_Detail_Info({Key? key, required this.name}) : super(key: key);

  @override
  State<stock_Detail_Info> createState() => _stock_Detail_InfoState();
}

class _stock_Detail_InfoState extends State<stock_Detail_Info> {
  double amount = 0;
  String unit = '';

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
            IconButton(onPressed: () {
              DatabaseHelper.instance.delete(widget.name);
            }

                , icon: const Icon(Icons.delete))
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('정보'),
              ),
              Tab(
                child: Text('내역'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FirstPage(name: widget.name),
            Center(
              child: SecondPage(),
            ),
          ],
        ),
      ),
    );
  }
}
