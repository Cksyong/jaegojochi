import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jaegojochi/db/Utility.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'add_Stock_page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';
import 'package:cross_file_image/cross_file_image.dart';

void main() {
  runApp(const MyApp());
}

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
        primarySwatch: createMaterialColor(Color(0xfff5f5dc)),
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
  late Future<File> imageFile;
  late Image image;
  late List<Stock> stocks = [];

  //여기부터 디비용
  void initState() {
    super.initState();
    stocks = [];
    refreshlist();
  }

  refreshlist() {
    DatabaseHelper.instance.getStocks().then((imgs) {
      setState(() {
        stocks.clear();
        stocks.addAll(imgs);
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
      body:

      // Container(
      //   width: double.infinity,
      //   //height: double.infinity,
      //   alignment: Alignment.topLeft,
      //   child:
      //   Column(
      //     mainAxisSize: MainAxisSize.max,
      //     children: [Container(
      //       child:
            // stocks.isEmpty
            //     ? Container(
            //   // width: double.infinity,
            //   //height: double.infinity,
            // )
            //     :
            ListView.builder(
                    itemCount: stocks.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        // width: double.infinity,
                        // height: double.infinity,
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // GridView.count(crossAxisCount: 1,
                            // mainAxisSpacing: 3,
                            // crossAxisSpacing: 3,
                            // childAspectRatio: 1.0,
                            // children: stocks.map((asd){
                            //   return Utility.imageFromBase64String(stocks[index].name.toString());
                            // }).toList(),),

                            //Image(image: FileImage(File(stocks[index].image!))),

                            Container(
                              width: 30,
                                height: 30,
                                // decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //         image: FileImage(File('/data/user/0/com.jhkorea.jaegojochi/cache/image_picker3638832145286108478.jpg'))
                                //     )
                                // )
                              child: Image(image: FileImage(File(stocks[index].image!))),
                            ),
                            Text(stocks[index].name.toString()),
                            Text(stocks[index].amount.toString() +
                                stocks[index].unit.toString()),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              stock_Detail_Info(
                                                name: stocks[index]
                                                    .name
                                                    .toString(),
                                              )));
                                },
                                icon: Icon(Icons.menu))
                          ],
                        ),
                      );
                    }),
      //     ),
      //  ]),
      //
      // ),
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
