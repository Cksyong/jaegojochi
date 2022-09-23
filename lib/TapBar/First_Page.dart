import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../db/DatabaseHelper.dart';
import '../db/Stock.dart';
import '../manage_Stock_page.dart';

class FirstPage extends StatefulWidget {
  final String name;

  const FirstPage({Key? key, required this.name}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double amount = 0;
  String unit = '';

  List<Stock> selectStock = [Stock(name:'default',amount: 'default',unit: 'default',)];

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
              image: element.image,
              code: element.code));
        });
      });
    }).catchError((error) {
      log(error);
    });
    log(selectStock[0].name.toString());




  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: selectStock[1].image!.toString() == '' //IF DB DOESN'T HAVE IMAGE
                  ? Image.asset(
                // SHOW DEFAULT
                'assets/image/no_stock_image.jpg',
              )
                  : Image.memory(
                // SHOW ITS IMAGE
                Base64Decoder().convert(selectStock[1].image!),
              )),
          Container(
            color: Colors.green,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              selectStock[1].name.toString(),
              //style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(selectStock[1].code != 0 ?
            selectStock[1].code.toString() : '',
              //style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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

          log("hi");
          log(selectStock[1].name.toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      manage_Stock_page(name: selectStock[1].name.toString())));
        },
        child: const Icon(Icons.edit_calendar_rounded),
      ),
    );
  }
}
