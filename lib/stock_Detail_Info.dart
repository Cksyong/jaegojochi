import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'db/DatabaseHelper.dart';
import 'db/Stock.dart';
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

  List<Stock> selectStock = [Stock(name:'default',amount: 'default',unit: 'default',image: 'default')];

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getSelectStock(widget.name).then((value) {
      setState(() {
        value.forEach((element) {
          selectStock.add(Stock(
              name: element.name,
              amount: element.amount,
              unit: element.unit,
              image: element.image));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세페이지'),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: selectStock[1].image!.isEmpty //IF DB DOESN'T HAVE IMAGE
                  ? Image.asset(  // SHOW TAKOYAKI
                'assets/image/no_stock_image.jpg',
              )
                  : SizedBox(
                width: 300,
                height: 300,// IF HAVE IMAGE
                child: Image( // SHOW ITS IMAGE
                    image: FileImage(File(selectStock[1].image!))),
              ),
          ),
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              selectStock[1].name.toString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 0, height: 100),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                child: Text(selectStock[1].amount.toString(),
                    style:
                        const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Text(selectStock[1].unit.toString(),
                    style:
                        const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => manage_Stock_page(
                        name: selectStock[1].name!,
                      )));
        },
        child: const Icon(Icons.edit_calendar_rounded),
      ),
    );
  }
}
