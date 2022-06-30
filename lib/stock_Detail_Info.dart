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
        title: const Text('상세페이지'),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Image.asset('assets/image/takoyaki.jpg')),
          Container(
            color: Colors.yellow,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: const Text(
              '상품명',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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
                child: const Text('8',
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Text('EA',
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
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
                  builder: (context) => const manage_Stock_page()));
        },
        child: const Icon(Icons.edit_calendar_rounded),
      ),
    );
  }
}
