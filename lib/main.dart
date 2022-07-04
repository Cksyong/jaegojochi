import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaegojochi/add_Stock_page.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'package:localstorage/localstorage.dart';

void main() {
  runApp(const MyApp());
}
// 앱바 색깔 설정
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red,
        g = color.green,
        b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xfff5f5dc)),
      ),
      home: mainPage(),
    );
  }
}

class mainPage extends StatefulWidget {

  // final List<Stock> = List
  const mainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class StockItem {
  String title;
  int amount;

  StockItem({required this.title, required this.amount});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['title'] = title;
    m['amount'] = amount;

    return m;
  }
}

class StockList {
  List<StockItem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}


//메인 시작
class _mainPageState extends State<mainPage> {

  //여기서부터 로컬 db 시작
  final StockList list = new StockList();
  final LocalStorage storage = new LocalStorage('stock_app');
  bool initialized = false;

  _addItem(String title, int amount) {
    setState(() {
      final item = StockItem(title: title, amount: amount);
      list.items.add(item);
      _saveToStorage;
    });
  }

  _saveToStorage() {
    storage.setItem('stocks', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('stocks') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    //var stockList = ['1', '2', '3', '4', '5', '7', '8', '9', '0'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고'),
      ),
      body: Container(
        child: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child : CircularProgressIndicator(),
              );
            }
            if(!initialized){
              var items = storage.getItem('stocks');

              if(items != null){
                list.items = List<StockItem>.from (
                    (items as List).map(
                        (item) => StockItem(
                          title : item['title'],
                          amount : item['amount'],
                        ),
                    ),
                );
              }
              initialized = true;
            }

            List<Widget> widgets = list.items.map((item) {
                return ListView.separated(itemBuilder: (context, index) {
                  return Container(padding: const EdgeInsets.fromLTRB(
                      15, 0, 0, 0),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/image/takoyaki.jpg',
                              width: 80,
                              height: 80,
                              alignment: Alignment.centerLeft),
                          Text(item.title),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            stock_Detail_Info()));
                              },
                              icon: Icon(CupertinoIcons.ellipsis_vertical))
                        ],
                      ));
                }, separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 1);
                }, itemCount: list.items.length);
              }).toList();

            return Column(
              children: <Widget>[
                Expanded(child: ListView(children: widgets,itemExtent: 50.0,))
              ]
            );
            }
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const add_Stock_page()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}