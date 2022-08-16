import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jaegojochi/add_Stock_page.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'Search_Page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'BUR/dataBackupRestore.dart';

//파이어베이스 쓸때 필요
// import 'package:firebase_core/firebase_core.dart';
//
// import 'firebase_options.dart';
//
//
// // ...
//
//
// await Firebase.initializeApp(
//
// options: DefaultFirebaseOptions.currentPlatform,
//
// );

final GoogleSignIn googleSignIn = GoogleSignIn();


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();

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
        primarySwatch: createMaterialColor(const Color(0xfff5f5dc)),
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
  String _scanBarcode = '';

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


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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

    var isExistBarcode = false;
    setState(() {
      _scanBarcode = barcodeScanRes;
      for (int i = 0; i < stocks.length; i++) {
        if (stocks[i].code == _scanBarcode) {
            isExistBarcode = true;
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (__) =>
                stock_Detail_Info(name: stocks[i].name.toString(),)));
            break;
        }
      }
      if (!isExistBarcode && barcodeScanRes != '-1') {
        Navigator.of(context)
            .push(MaterialPageRoute(
            builder: (__) => add_Stock_page(barcode: _scanBarcode)));
      }
    });
  }

  List<Stock> stocks = [];


  void initState() {
    super.initState();
    stocks = [];
    refreshlist();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

  }

  refreshlist() {
    DatabaseHelper.instance.getStocks().then((imgs) {
      setState(() {
        stocks.clear();
        stocks.addAll(imgs);
      });
    });
  }

  _deleteSureDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10.0)),
              title: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("전체 데이터 삭제"),
                ],),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: const <Widget>[
                  Text("백업되지 않은 데이터는 복구할 수 없습니다.\n계속하시겠습니까?")
                ],),
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
                    setState(() {
                    for (var i = 0; i<stocks.length; i++) {
                      DatabaseHelper.instance.deleteLog(stocks[i].name!);
                    }
                    stocks.clear();
                    DatabaseHelper.instance.clearTable();
          } );

                    Navigator.pop(context);
                  },
                  child: const Text("확인"),
                ),

              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고최고'),
        actions: [
          IconButton(
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
                stocks[index].image!.toString() == '' //IF DB DOESN'T HAVE IMAGE
                    ? Image.asset(
                        // SHOW TAKOYAKI
                        'assets/image/no_stock_image.jpg',
                  width: MediaQuery.of(context).size.height*0.069,
                  height: MediaQuery.of(context).size.height*0.069,
                  fit: BoxFit.fill,
                      )
                    : Container(
                        // IF HAVE IMAGE
                  width: MediaQuery.of(context).size.height*0.069,
                  height: MediaQuery.of(context).size.height*0.069,
                        child: Image.memory(
                            // SHOW ITS IMAGE
                             /*FileImage(File(stocks[index].image!))*/
                            Base64Decoder().convert(stocks[index].image!),
                            fit: BoxFit.cover),
                      ),
                Container(
                  width: MediaQuery.of(context).size.width*0.4,
                  alignment: Alignment.center,
                  child: Text(stocks[index].name.toString(),
                    overflow: TextOverflow.ellipsis,),
                  // DB NAME
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  alignment: Alignment.center,
                  child: Text(stocks[index].amount.toString() + // DB AMOUNT
                      stocks[index].unit.toString()),
                ),
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
                      builder: (context) => add_Stock_page(barcode: '',)));
            },
          ),
          SpeedDialChild(
              child: const Icon(Icons.qr_code_scanner_outlined),
              label: '바코드 스캔',
              backgroundColor: const Color(0xfff5f5dc),
              onTap: () => scanBarcodeNormal()),
          SpeedDialChild(
              child: const Icon(Icons.backup),
              label: '데이터 백업',
              backgroundColor: const Color(0xfff5f5dc),
              onTap: () {
                Fluttertoast.showToast(
                    msg: '데이터 백업/복원을 위해 구글 로그인이 필요합니다.',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM);
                signInWithGoogle()
                    .then((value) =>
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const dataBackupRestore())
                )
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.restart_alt),
              label: '전체 데이터 삭제',
              backgroundColor: const Color(0xfff5f5dc),
              onTap: () { _deleteSureDialog(); }),
        ],
      ),
    );
  }
}
