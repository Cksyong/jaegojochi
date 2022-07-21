import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaegojochi/db/Utility.dart';
import 'dart:developer';

import 'TapBar/First_Page.dart';
import 'TapBar/Second_Page.dart';
import 'db/DatabaseHelper.dart';
import 'db/Stock.dart';
import 'main.dart';
import 'manage_Stock_page.dart';

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
            FirstPage(name: widget.name),
            Center(
              // child: SecondPage(),
            ),
          ],
        ),
      ),
    );
  }
}
