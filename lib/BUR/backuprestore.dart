import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../db/DatabaseHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../db/Stock.dart';

class backuprestore extends StatefulWidget{
  const backuprestore({Key? key,}) : super(key: key);


  @override
  State<backuprestore> createState() => _backuprestore();
}

class _backuprestore extends State<backuprestore> {


  String _currentUser = '';

  List<Stock> stocks = [];
  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = auth.currentUser!.email.toString();
    DatabaseHelper.instance.getStocks().then((value) {
      setState(() {
        stocks.clear();
        stocks.addAll(value);
      });
    }).catchError((error) {
    });
  }

  Future<UserCredential> signInWithGoogle(bool isAlreadyLogin) async {
    // Trigger the authentication flow
      googleSignIn.signOut();

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



  GoogleSignIn googleSignIn = GoogleSignIn();

  var db = FirebaseFirestore.instance;
  restoreData() {


    print(_currentUser);
    DatabaseHelper.instance.clearTable();
    db.collection(_currentUser).get().then((event) {
      for (var doc in event.docs) {
        print("${doc["amount"]}");
// stocks.add(Stock(name: doc['name'], amount: doc['amount'], code: doc['code'], unit: doc['unit'], image: doc['image']));
        DatabaseHelper.instance
            .insert(Stock(name: doc['name'], amount: doc['amount'], code: doc['code'], unit: doc['unit'], image: doc['image']));
      }

    }).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
            const mainPage()),
            (route) => false));
  }

  void backUpData() {



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
      db.collection(_currentUser).doc(stocks[i].name).set(backUpData);

    }
    Navigator.pop(context);
  }

  void _showDialog(bool method) {
    String methodString = '';
    if (method) {
      methodString = '이전에 백업된 데이터는 유지되지 않습니다.\n계속하시겠습니까?';
    } else if (!method) {
      methodString = '데이터 복원 시 기존에 있던 데이터는 사라집니다.\n계속하시겠습니까?';
    }
      showDialog(
          context: context,
          barrierDismissible: false, //Dialog 제외한 다른 화면 터치 x
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Column(
                children: const <Widget>[
                  Text("데이터를 백업하시겠습니까?"),
                ],),
              //
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(methodString),],),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);},
                  child: const Text("취소"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black),
                  onPressed: () {
                    if (method) {
                      backUpData();

                    } else if (!method) {
                      restoreData();
                    }

                  },
                  child: const Text("확인"),
                ),],);
          });

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
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('구글 계정을 통해\n재고최고 서버에 데이터를 백업하거나\n서버에 백업된 데이터를 불러올 수 있습니다.',
            textAlign: TextAlign.center,),
            Column(
              children: [
                Text('현재 로그인 계정 : $_currentUser'),
                ElevatedButton(onPressed: () {
                signInWithGoogle(true);
                    FirebaseAuth auth = FirebaseAuth.instance;
                    _currentUser = auth.currentUser!.email.toString();}
                , child: Text('변경하기'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(onPressed: (){_showDialog(true);}, child: const Text('백업하기') ),
                ElevatedButton(onPressed: (){_showDialog(false);}, child: const Text('복원하기') ),
              ],
            ),


          ],
        ),

      )
    );
  }
}
