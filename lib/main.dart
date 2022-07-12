import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaegojochi/manage_Stock_page.dart';
import 'package:sqflite/sqflite.dart';

import 'add_Stock_page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';

void main() {
  runApp(const MyApp());
}
 n

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

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
        primarySwatch: createMaterialColor(Color(0xff000000)),
      ),
      home: const mainPage(),
    );
  }
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key}) : super(key: key);


  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  TextEditingController textController = new TextEditingController();
  // XFile? pickedImage;


  //여기부터 디비용
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          stockList.add(Stock(
              name: element['name'],
              amount: element['amount'],
              unit: element['unit']),
          );
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _deleteTask(String name) async {
    await DatabaseHelper.instance.delete(name);
    setState(() {
      stockList.removeWhere((element) => element.name == name);
    });
  }

  List<Stock> stockList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              child: stockList.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: stockList.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/image/takoyaki.jpg',
                                width: 80,
                                height: 80,
                                alignment: Alignment.centerLeft,
                              ),
                              Text(stockList[index].name),
                              Text(stockList[index].amount.toString() +
                                  stockList[index].unit),
                              IconButton(
                                  onPressed: () =>
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => const manage_Stock_page())),
                                  icon: Icon(Icons.add))
                            ],
                          ),
                        );
                      }),
            ))
          ],
        ),
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
