import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class backuprestore extends StatefulWidget{
  const backuprestore({Key? key,}) : super(key: key);

  @override
  State<backuprestore> createState() => _backuprestore();
}

class _backuprestore extends State<backuprestore> {

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

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
            ElevatedButton(onPressed: (){}, child: const Text('백업하기') ),
            ElevatedButton(onPressed: (){}, child: const Text('복원하기') ),


          ],
        ),

      )
    );
  }
}
