
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';

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
      home: const mainPage(title : 'Listify'),
    );
  }
}

class mainPage extends StatefulWidget {
  const mainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {

  TextEditingController textController = new TextEditingController();

  //여기부터 디비용
  void initState(){
    super.initState();
    DatabaseHelper.instance.queryAllRows().then((value){
      setState(() {
        value.forEach((element) {
          stockList.add(Stock(name: element['name'], amount: element['amount'], unit: element['unit']));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  void _addToDB() async{
    String name = textController.text;
    int amount = 50;
    String unit = 'EA';
    setState((){
      stockList.insert(0,Stock(name: name, amount: amount, unit: unit) );
    });
    textController.text = "";
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
          title: const Text('재고최고'),
        ),
        body: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: TextFormField(
                    decoration: InputDecoration(hintText:"Enter a task"),
                    controller: textController,
                  ),),
                  IconButton(onPressed: _addToDB, icon: Icon(Icons.add))
                ],
              ),
              SizedBox(height: 20),
              Expanded(child: Container(
                child:stockList.isEmpty ?Container() :
                ListView.builder(
                    itemBuilder: (ctx, index){
                      if (index == stockList.length) { return Text('${stockList.length}');}
                      return ListTile(
                          title : Text(stockList[index].name),
                          leading: Text(stockList[index].amount.toString() + stockList[index].unit),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: ()=> _deleteTask(stockList[index].name),
                          )
                      );
                    }),
              ))
            ],
          ),



        )
    );
  }
}
