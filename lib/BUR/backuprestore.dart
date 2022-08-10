import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../db/DatabaseHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../db/Stock.dart';

class backuprestore extends StatefulWidget{
  const backuprestore({Key? key,}) : super(key: key);

  @override
  State<backuprestore> createState() => _backuprestore();
}






class _backuprestore extends State<backuprestore> {

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  var db = FirebaseFirestore.instance;
  restoreData() {



    db.collection(auth.currentUser.toString()).get().then((event) {
      for (var doc in event.docs) {
// print("${doc["amount"]}");
// stocks.add(Stock(name: doc['name'], amount: doc['amount'], code: doc['code'], unit: doc['unit'], image: doc['image']));
        DatabaseHelper.instance
            .insert(Stock(name: doc['name'], amount: doc['amount'], code: doc['code'], unit: doc['unit'], image: doc['image']));
      }
    });
  }

  void backUpData() {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<Stock> stocks = [];
    print(auth.currentUser.toString());
    DatabaseHelper.instance.getStocks().then((imgs) {
      setState(() {
        stocks.clear();
        stocks.addAll(imgs);
      });
    });


    for (int i = 0; i<stocks.length; i++) {
      final backUpData = <String, dynamic> {
        'amount' : stocks[i].amount,
        'name' : stocks[i].name,
        'code' : stocks[i].code,
        'image' : stocks[i].image,
        'unit' : stocks[i].unit
      };
      db.collection(auth.currentUser.toString()).doc(stocks[i].name).set(backUpData);

    }
  }

  @override
  void dispose(){
    googleSignIn.signOut();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("재고최고 / 백업 및 복원"),
      ),
      // body: !_searchBoolean ? _defaultListView() : _searchListView()
      body: Container(
        color: Colors.cyan,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){backUpData();}, child: const Text('백업하기') ),
            ElevatedButton(onPressed: (){restoreData();}, child: const Text('복원하기') ),


          ],
        ),

      )
    );
  }
}
