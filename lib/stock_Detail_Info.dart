import 'package:flutter/material.dart';
import 'package:jaegojochi/manage_Stock_page.dart';

class stock_Detail_Info extends StatefulWidget {
  const stock_Detail_Info({Key? key}) : super(key: key);

  @override
  State<stock_Detail_Info> createState() => _stock_Detail_InfoState();
}

class _stock_Detail_InfoState extends State<stock_Detail_Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재고 수정'),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/image/takoyaki.jpg')),
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Text('상품명',style: TextStyle(fontSize: 30, fontWeight:FontWeight.bold),),
          )
        ],
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const manage_Stock_page()));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
    );
  }
}
