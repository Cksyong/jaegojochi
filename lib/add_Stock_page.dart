import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'db/DatabaseHelper.dart';
import 'db/Stock.dart';
import 'main.dart';

class add_Stock_page extends StatefulWidget {
  const add_Stock_page({Key? key}) : super(key: key);

  @override
  State<add_Stock_page> createState() => _add_Stock_pageState();
}

class _add_Stock_pageState extends State<add_Stock_page> {
  late Future<File> imageFile;
  late Image image;
  late DatabaseHelper dbHelper;
  late List<Stock> stocks;

  void addToDB(dynamic image) {
    String name = productNameController.text;
    String amount = productAmountController.text;
    String unit = _selectedValue.toString();
    log('addToDB');
    String fileEdit = "";

    // IF USER DOESN'T UPLOAD AN IMAGE
    if(image != null){
      File? file = File(image!.path);
      fileEdit = file.toString();
      fileEdit = fileEdit.substring(0, fileEdit.length -1);
      fileEdit = fileEdit.replaceAll('File: \'', '');
    }
    if(amount.startsWith('.') == true){
      amount = '0$amount';
    }
    log(fileEdit);
    setState(() {
      stockList.insert(
          0, Stock(name: name, amount: amount, unit: unit, image: fileEdit));
    });
    DatabaseHelper.instance
        .insert(Stock(name: name, amount: amount, unit: unit, image: fileEdit));
  }


  List<Stock> stockList = [];
  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  final _unitValue = ['EA', 'kg', 'g', 'L', 'ml', 'cm', 'm', 'oz'];
  var _selectedValue = 'EA';
  final productNameController = TextEditingController();
  final productAmountController = TextEditingController();
  dynamic imageString;

  @override
  Widget build(BuildContext context) {
    void showToast(String message) {
      Fluttertoast.showToast(
          msg: '$message을 입력해주세요.',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }

    void addProductDialog() {
      var name = productNameController.text;
      var amount = productAmountController.text;
      if(amount.startsWith('.') == true){
        amount = '0$amount';
      }
      if (name == "") {
        showToast('품목명');
        //TODO Toast외않됌?
      } else if (amount.toString() == "") {
        showToast('수량');
      } else {
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
                    Text("추가할 품목을 확인하세요."),
                  ],
                ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '품목명 : $name \n수량 : $amount($_selectedValue)\n 추가하시겠습니까?'),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("취소"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      addToDB(_imageFile);
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => mainPage()),
                          (route) => false);
                    },
                    child: const Text("확인"),
                  ),
                ],
              );
            });
      }
    }

    bool _textVisibility = true;
    bool _imageVisibility = false;

    void _textHide() {
      setState(() {
        _textVisibility = false;
        _imageVisibility = true;
      });
    }

    void _textShow() {
      setState(() {
        _textVisibility = true;
        _imageVisibility = false;
      });
    }

    return GestureDetector(
        onTap: (){
      FocusScopeNode currentFocus = FocusScope.of(context);

      if(!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },
    child : Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text('품목 추가'),
        centerTitle: true, //툴바 타이틀 가운데정렬
        elevation: 0.0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 70.0, left: 50.0, right: 50.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 300,
                child: TextButton(
                  onPressed: () {
                    _textHide();
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()));
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    onSurface: Colors.grey,
                    backgroundColor: Colors.grey,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        visible: _textVisibility,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: true,
                          child: Image(
                            image: _imageFile == null
                                ? const AssetImage(
                                'assets/image/add_image_button.jpg')
                            as ImageProvider
                                : FileImage(File(_imageFile.path)),
                          ))
                    ],
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: '품목명',
                    labelStyle: TextStyle(color: Colors.black)),
                controller: productNameController,
              ),
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  width: 60,
                  height: 50,
                  child: TextField(
                    maxLines: 1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                    ], //double 타입 전용 조건
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: '수량',
                        labelStyle: TextStyle(color: Colors.black)),
                    controller: productAmountController,
                  ),
                ),
                DropdownButton(
                    value: _selectedValue,
                    items: _unitValue.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value.toString();
                      });
                    })
              ],
            ),
            Container(
                width: double.infinity,
                child: TextButton(
                    onPressed: () => addProductDialog(),
                    style: TextButton.styleFrom(
                        primary: Colors.black,
                        onSurface: Colors.grey,
                        backgroundColor: Colors.grey),
                    child: const Text('추가하기')))
          ],
        ),
      ),
    ));
  }

  Widget bottomSheet() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text('사진 선택'),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.camera,
                  size: 50,
                ),
                label: const Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.photo_library,
                  size: 50,
                ),
                label: const Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

}
