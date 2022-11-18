import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jaegojochi/MySharedPerferences.dart';
import 'package:jaegojochi/add_Stock_page.dart';
import 'package:jaegojochi/main.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'Search_Page.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'BUR/dataBackupRestore.dart';
import 'firebase_options.dart';

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

class LoginMainPage extends StatefulWidget {

  const LoginMainPage({Key? key}) : super(key: key);

  @override
  State<LoginMainPage> createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
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


  Future<String> signInWithGoogle() async {
    // Trigger the authentication flow
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
    await FirebaseAuth.instance.signInWithCredential(credential);
    return '구글 로그인 성공';
  }

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 70.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '재고최고',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      label: Text('회원(온라인) 모드'),
                      icon: Icon(Icons.account_balance_wallet_rounded),
                      onPressed: () {
                        signInWithGoogle().then((value) {
                          MySharedPreferences.instance.setBooleanValue("loggedin", true);
                          MySharedPreferences.instance.setBooleanValue("online", true);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const mainPage())
                         );
                        });
                      },
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.7,
                        child: Flexible(
                            child: RichText(
                              maxLines: 5,
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black),
                                  text:
                                  '등록한 물품은 자동으로 재고최고 서버에 업로드됩니다.\n인터넷 연결이 필요하며,\n기기 변경이나 데이터 손실 시 복구가 가능합니다.'),
                              overflow: TextOverflow.ellipsis,
                            )))
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      label: Text('비회원(오프라인) 모드'),
                      icon: Icon(Icons.phone_android),
                      onPressed: () {
                        MySharedPreferences.instance.setBooleanValue("loggedin", true);
                        MySharedPreferences.instance.setBooleanValue("online", false);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const mainPage())
                        );
                      },
                    ),
                    Text(
                      '등록한 물품은 기기에만 저장되며,\n저장된 데이터는 앱 삭제 시 사라집니다.\n백업하지 않은 데이터는 복구가 불가합니다.',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfff5f5dc),
    );
  }
}
