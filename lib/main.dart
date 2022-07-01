import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:jaegojochi/add_Stock_page.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';

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
      home: mainPage(
        stock: List.generate(10, (i) => StockTable('상품 ${i+1}', 'EA', 85))
      ),
    );
  }
}

class StockTable {
  final String name;
  final String unit;
  final double amount;

  StockTable(this.name, this.unit, this.amount);

}


class mainPage extends StatefulWidget {

  final List<StockTable> stock;
  const mainPage({
    Key? key, required this.stock,
  }) : super(key: key);

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {

  @override
  Widget build(BuildContext context) {
    var stockList = ['1', '2', '3', '4', '5', '7', '8', '9', '0'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고'),
      ),
      body: Container(
        color: Colors.black12,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          itemCount: widget.stock.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/image/takoyaki.jpg',
                      width: 80, height: 80, alignment: Alignment.centerLeft),
                  Text(widget.stock[index].name),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => stock_Detail_Info(stockIn: widget.stock[index],)));
                      },
                      icon: Icon(CupertinoIcons.ellipsis_vertical))
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(thickness: 1);
          },
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
