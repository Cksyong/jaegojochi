import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jaegojochi/db/DatabaseHelper.dart';
import 'package:jaegojochi/db/Stock.dart';
import 'package:jaegojochi/manage_Stock_page.dart';

class FirstPage extends StatefulWidget {
  final String name;

  const FirstPage({Key? key, required this.name}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  List<Stock> selectStock = [
    Stock(name: 'default', amount: 'default', unit: 'default', image: 'default')
  ];

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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child:
          selectStock[1].image!.isEmpty //IF DB DOESN'T HAVE IMAGE
              ? Image.asset(
            // SHOW DEFAULT
            'assets/image/no_stock_image.jpg',
          )
              : Image(
                // SHOW ITS IMAGE
                  image: FileImage(File(selectStock[1].image!)),
          )
          ),
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              selectStock[1].name.toString(),
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
                    //style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Text(selectStock[1].unit.toString(),
                    //style:TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
                ),
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
                  builder: (context) =>
                      manage_Stock_page(name: selectStock[1].name.toString())));
        },
        child: const Icon(Icons.edit_calendar_rounded),
      ),
    );
  }
}
