import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jaegojochi/db/DatabaseHelper.dart';
import 'package:jaegojochi/db/Stock.dart';
import 'package:jaegojochi/main.dart';

class manage_Stock_page extends StatefulWidget {
  final String name;

  const manage_Stock_page({Key? key, required this.name}) : super(key: key);

  @override
  State<manage_Stock_page> createState() => _manage_Stock_pageState();
}

class _manage_Stock_pageState extends State<manage_Stock_page> {
  List<Stock> selectStock = [];
  List<Stock> updateStock = [];

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

  final ImagePicker _picker = ImagePicker();
  dynamic _imageFile;
  var _isBeforeImage = true;
  var _isAfterImage = false;
  final productAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {



    void _showAlertDialog(String way, String message) {
      showDialog(
          context: context,
          //barrierDismissible - Dialog 제외한 다른 화면 터치 x
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              title: Column(
                children: const <Widget>[
                  Text("수량을 확인하세요."),
                ],
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    //TODO DB(내부저장소든 뭐든)에 추가하는 코드
                    Navigator.pop(context);
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          });
    }

    void editProductState(String method) {
      var amountText = productAmountController.text;
      double amount = 0;
      double finalAmount = 0;
      if (amountText != '') {
        amount = double.parse(amountText);
      }
      if (amount == 0) {
        _showAlertDialog('', '추가/소진할 수량을 입력해주세요.');
      } else if (method == '소진' &&
          double.parse(selectStock[0].amount!) < amount) {
        _showAlertDialog('', '소진할 수량은 현재 수량을 초과할 수 없습니다.');
      } else {

        if (method == '추가') {
          finalAmount = double.parse(selectStock[0].amount!) + amount;
        } else if (method == '소진') {
          finalAmount = double.parse(selectStock[0].amount!) - amount;
        }
        showDialog(
            context: context,
            //barrierDismissible - Dialog 제외한 다른 화면 터치 x
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                //Dialog Main Title
                title: Column(
                  children: const <Widget>[
                    Text("수량을 확인하세요."),
                  ],
                ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '현재 수량 : ${selectStock[0].amount} ${selectStock[0].unit}\n변경 수량 : $amount (${selectStock[0].unit!})\n최종 수량 : ${finalAmount}\n$method하시겠습니까?',
                    ),
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
                      //TODO DB(내부저장소든 뭐든)에 추가하는 코드
                      updateStock = selectStock;
                      if(_imageFile != null){
                        File? file = File(_imageFile!.path);
                        var fileEdit = file.toString();
                        var fileEdit2 = fileEdit.substring(0, fileEdit.length -1);
                        var fileEdit3 = fileEdit2.replaceAll('File: \'', '');
                       updateStock[0].image = fileEdit3;
                      }
                      updateStock[0].amount = finalAmount.toString();
                      //TODO 아직 몇발 남았다 20220714
                      DatabaseHelper.instance.update(updateStock[0]);
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

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if(!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child : Scaffold(
        resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '재고 추가/소진',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true, //툴바 타이틀 가운데정렬
        elevation: 0.0,
      ),
      body: Container(
          // width: double.infinity,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                child: Text(
                  selectStock[0].name!,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Text('재고 사진을 수정하려면 아래 사진을 클릭해주세요.'),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.33,
                margin: EdgeInsets.only(top: 20),
                padding: const EdgeInsets.fromLTRB(80, 5, 80, 10),
                child: OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: _isBeforeImage,
                          child: selectStock[0].image!.isEmpty //IF DB DOESN'T HAVE IMAGE
                                ? Image.asset(  // SHOW TAKOYAKI
                              'assets/image/no_stock_image.jpg',
                            )
                                : Container( // IF HAVE IMAGE
                              width: 300,
                              height: 300,
                              child: Image( // SHOW ITS IMAGE
                                  image: FileImage(File(selectStock[0].image!))),
                            ),

                          ),
                      Visibility(visible: _isAfterImage,
                          child: Image(
                            image: _imageFile == null
                                ? FileImage(File(selectStock[0].image!))
                            as ImageProvider
                                : FileImage(File(_imageFile.path)),
                          ))
                    ],
                  ),







                ),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: const Text('추가/소진할 수량을 입력해주세요.')),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      '현재 수량 ', style: TextStyle(fontSize: 20),
                      // '${widget.amount.toString()} '
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                      child: Text(
                        selectStock[0].amount.toString(),
                        style: TextStyle(fontSize: 20),
                        // widget.unit
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          width: 70,
                          height: 45,
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
                            ],
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: '수량',
                              hintStyle: TextStyle(fontSize: 17),
                            ),
                            controller: productAmountController,
                          ),
                        ),

                        Text(selectStock[0].unit!
                            )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        editProductState('추가');
                      },
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.black,
                        // onSurface: Colors.grey,
                        fixedSize: Size(100, 50),
                      ),
                      // backgroundColor: Colors.black),
                      child: const Text(
                        '추 가',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        editProductState('소진'); }                      ,
                      // => editProductState('소진'),
                      style: TextButton.styleFrom(
                        //     primary: Colors.black,
                        //     onSurface: Colors.grey,
                        fixedSize: Size(100, 50),
                      ),
                      //     backgroundColor: Colors.black),
                      child: const Text(
                        '소 진',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    )
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text('사진 선택'),
          SizedBox(
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
                icon: Icon(
                  Icons.camera,
                  size: 50,
                ),
                label: Text('Camera'),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.photo_library,
                  size: 50,
                ),
                label: Text('Gallery'),
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
      _isBeforeImage = false;
      _isAfterImage = true;
      _imageFile = pickedFile;
    });
  }

}
