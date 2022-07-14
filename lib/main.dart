import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'add_Stock_page.dart';
import 'db/Search_Page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // FROM HERE
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
  } //TO HERE APP BAR COLOR CHANGING

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
  late Future<File> imageFile;
  late Image image;
  late List<Stock> stocks = [];

  // FROM HERE
  @override
  void initState() {
    super.initState();
    stocks = [];
    refreshList();
  }

  refreshList() {
    DatabaseHelper.instance.getStocks().then((imgs) {
      setState(() {
        stocks.clear();
        stocks.addAll(imgs);
      });
    });
  }
 // TO HERE DB INITIALIZE AND ADD TO LIST


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고'),
        actions: [
          IconButton(
            // onPressed: (){},
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (__) => SearchPage())),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body:
          ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ stocks[index].image!.isEmpty //IF DB DOESN'T HAVE IMAGE
                          ? Image.asset(  // SHOW TAKOYAKI
                              'assets/image/takoyaki.jpg',
                              width: 80,
                              height: 80,
                            )
                          : Container( // IF HAVE IMAGE
                              width: 80,
                              height: 80,
                              child: Image( // SHOW ITS IMAGE
                                  image: FileImage(File(stocks[index].image!))),
                            ),
                      Text(stocks[index].name.toString()), // DB NAME
                      Text(stocks[index].amount.toString() + // DB AMOUNT
                          stocks[index].unit.toString()), // UNIT
                      IconButton( // MOVE TO ITS stock_Detail_Info
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => stock_Detail_Info(
                                          name: stocks[index].name.toString(),
                                        )));
                          },
                          icon: const Icon(Icons.more_vert)
                      )],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton( // MOVE TO add_Stock_Page
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
