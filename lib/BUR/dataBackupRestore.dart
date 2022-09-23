import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../db/DatabaseHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import '../db/Stock.dart';
import '../db/Log.dart';

class dataBackupRestore extends StatefulWidget {
  const dataBackupRestore({
    Key? key,
  }) : super(key: key);

  @override
  State<dataBackupRestore> createState() => _backuprestore();
}

class _backuprestore extends State<dataBackupRestore> {
  String _currentUser = '';

  List<Stock> stocks = [];
  List<LogData> logs = [];

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = auth.currentUser!.email.toString(); //로그인 EMail 확인
    DatabaseHelper.instance.getStocks().then((value) { //로그를 제외한 Stocks.db 불러오기
      setState(() {
        stocks.clear();
        stocks.addAll(value);
      });
    }).catchError((error) {});
  }

  Future<UserCredential> signInWithGoogle(bool isAlreadyLogin) async { //구글 로그인 전용함수
    // Trigger the authentication flow
    googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

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

  void logRestoreProcess(String name) { //데이터 복원 - 로그 저장 함수
    db.collection(_currentUser)
        .doc(name)
        .collection('logData')
        .get()
        .then((value) {
      DatabaseHelper.instance.onCreateLog(name);
      for (var doc in value.docs) {
        DatabaseHelper.instance.insertLog(
            LogData(
                date: doc['date'],
                up: doc['up'],
                down: doc['down'],
                total: doc['total']),
            name);
      }
    });
  }

  restoreData() { //데이터 복원 함수
    DatabaseHelper.instance.clearTable();
    db.collection(_currentUser).get().then((event) {
      for (var doc in event.docs) {
        DatabaseHelper.instance.insert(Stock(
            name: doc['name'],
            amount: doc['amount'],
            code: doc['code'],
            unit: doc['unit'],
            image: doc['image']));
        logRestoreProcess(doc['name']);
      }
    }).then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const mainPage()),
        (route) => false));
  }

  void backUpData() { //데이터 백업 함수
    for (int i = 0; i < stocks.length; i++) {
      final backUpData = <String, dynamic>{ //SQLite 데이터 매핑
        'amount': stocks[i].amount,
        'name': stocks[i].name,
        'code': stocks[i].code,
        'image': stocks[i].image,
        'unit': stocks[i].unit
      };

      db.collection(_currentUser).doc(stocks[i].name).set(backUpData);
      DatabaseHelper.instance.getStocksLog(stocks[i].name!).then((value) { //로그가 저장된 개별 db 파일 불러오기
        setState(() {
          logs.clear();
          logs.addAll(value);
        });
      }).then((value) {
        for (int j = 0; j < logs.length; j++) {
          var logData = <String, dynamic>{
            'date': logs[j].date,
            'up': logs[j].up,
            'down': logs[j].down,
            'total': logs[j].total
          };
          db
              .collection(_currentUser)
              .doc(stocks[i].name!)
              .collection('logData')
              .doc('${j + 1}')
              .set(logData);
        }
      });
    }
  }

  void _showDialog(bool method) {
    String methodString = '';
    String methodWay = '';
    if (method) {
      methodString = '이전에 백업된 데이터는 유지되지 않습니다.\n계속하시겠습니까?';
      methodWay = '백업';
    } else if (!method) {
      methodString = '데이터 복원 시 기존에 있던 데이터는 사라집니다.\n계속하시겠습니까?';
      methodWay = '복원';
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
              children: <Widget>[
                Text("데이터를 ${methodWay}하시겠습니까?"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(methodString),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("취소"),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () {
                  if (method) {
                    backUpData();
                  } else if (!method) {
                    restoreData();
                  }
                  Navigator.pop(context);
                },
                child: const Text("확인"),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
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
              Text(
                '구글 계정을 통해\n재고최고 서버에 데이터를 백업하거나\n서버에 백업된 데이터를 불러올 수 있습니다.',
                textAlign: TextAlign.center,
              ),
              Column(
                children: [
                  Text('현재 로그인 계정 : $_currentUser'),
                  ElevatedButton(
                      onPressed: () {
                        signInWithGoogle(true);
                        FirebaseAuth auth = FirebaseAuth.instance;
                        _currentUser = auth.currentUser!.email.toString();
                      },
                      child: Text('변경하기'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _showDialog(true);
                      },
                      child: const Text('백업하기')),
                  ElevatedButton(
                      onPressed: () {
                        _showDialog(false);
                      },
                      child: const Text('복원하기')),
                ],
              ),
            ],
          ),
        ));
  }
}
