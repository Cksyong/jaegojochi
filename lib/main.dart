import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:jaegojochi/add_Stock_page.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'Search_Page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(const MyApp());

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
  int _scanBarcode = 0;

  //FOR FAB
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  WillPopScope() async {
    if (isDialOpen.value) {
      isDialOpen.value = false;
      return false;
    } else {
      return true;
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = int.parse(barcodeScanRes);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (__) => add_Stock_page(barcode: _scanBarcode)));
    });
  }

  late Future<File> imageFile;
  late Image image;
  late List<Stock> stocks = [];

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고'),
        actions: [
          IconButton(
            // onPressed: (){},
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (__) => SearchPage())),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: stocks.length,
        itemBuilder: (ctx, index) {
          return Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stocks[index].image!.isEmpty //IF DB DOESN'T HAVE IMAGE
                    ? Image.asset(
                        // SHOW TAKOYAKI
                        'assets/image/no_stock_image.jpg',
                        width: 80,
                        height: 80,
                      )
                    : SizedBox(
                        // IF HAVE IMAGE
                        width: 80,
                        height: 80,
                        child: Image(
                            // SHOW ITS IMAGE
                            image: FileImage(File(stocks[index].image!))),
                      ),
                Text(stocks[index].name.toString()),
                // DB NAME
                Text(stocks[index].amount.toString() + // DB AMOUNT
                    stocks[index].unit.toString()),
                // UNIT
                IconButton(
                    // MOVE TO ITS stock_Detail_Info
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => stock_Detail_Info(
                            name: stocks[index].name.toString(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
            color: Colors.black,
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isDialOpen,
        backgroundColor: const Color(0xfff5f5dc),
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: '추가하기',
            backgroundColor: const Color(0xfff5f5dc),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => add_Stock_page(barcode: 0,)));
            },
          ),
          SpeedDialChild(
              child: const Icon(Icons.scanner),
              label: '바코드 입력',
              backgroundColor: const Color(0xfff5f5dc),
              onTap: () => scanBarcodeNormal())
        ],
      ),
    );
  }
}
