import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
    //인자로 받아온 name(상품명) 기본키로 선택된 재고를 DB에서 찾기
    super.initState();
    DatabaseHelper.instance.getSelectStock(widget.name).then((value) {
      setState(() {
        value.forEach((element) {
          selectStock.add(Stock(
              name: element.name,
              amount: element.amount,
              unit: element.unit,
              image: element.image,
          code: element.code));
          if (element.code != 0) {
            productCodeController.text = element.code.toString();
          }
        });
      });
    }).catchError((error) {
      print(error);
    });


  } //End Of initState()

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      if (barcodeScanRes != '-1') {
        productCodeController.text = barcodeScanRes;
      }
    });
  }

  final ImagePicker _picker = ImagePicker(); //카메라 또는 갤러리에서 사진 불러오는 기능
  dynamic _imageFile; //불러온 사진 데이터를 저장하는 변수
  var _isBeforeImage = true; //사진 변경 시 visibility를 조절하기 위한 변수
  var _isAfterImage = false;
  final productAmountController =
      TextEditingController(); //TextField에서 입력값 받아오는 컨트롤러
  var _codeIsEnable = false;
  var _codeChecked = false;
  final productCodeController = TextEditingController();

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
              children: const <Widget>[//다이얼로그 타이틀
                Text("수량을 확인하세요."),
              ],
            ),

            content: Column( //다이얼로그 본문
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton( //확인버튼만 있고 누르면 닫히고 끝
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("확인"),
              ),
            ],
          );
        });
  }

  void editProductState(String method) { //입력값에 따라 모든 행동을 총괄하는 함수
    //DB 업데이트 포함
    var amountText = productAmountController.text;//TextField 입력값 저장
    double amount = 0; //문자열인 입력값 변환하여 저장할 변수
    double finalAmount = 0; //추가/소진 연산 후 결과값을 저장할 변수
    if (amountText != '') { //수량이 입력되었으면
      amount = double.parse(amountText); //Double 타입으로 변환
    }
    if (productAmountController.text == '') { //수량이 비었거나 0이면
      _showAlertDialog('', '추가/소진할 수량을 입력해주세요.');
    } else if (method == '소진' &&
        double.parse(selectStock[0].amount!) < amount) { // '소진' 버튼을 눌렀는데 현재 값보다 입력값이 크면
      _showAlertDialog('', '소진할 수량은 현재 수량을 초과할 수 없습니다.');
    } else { //정상 입력, 정상 진행
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
                  Text('현재 수량 : ${selectStock[0].amount} ${selectStock[0].unit}\n변경 수량 : $amount (${selectStock[0].unit!})\n최종 수량 : $finalAmount\n$method하시겠습니까?'),
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
                    String img64 = '';
                    updateStock = selectStock;
                    if (_imageFile != null) {
                      // File? file = File(_imageFile!.path);
                      // var fileEdit = file.toString();
                      // var fileEdit2 =
                      // fileEdit.substring(0, fileEdit.length - 1);
                      // var fileEdit3 = fileEdit2.replaceAll('File: \'', '');
                      var bytes = File(_imageFile!.path).readAsBytesSync();
                      img64 = base64Encode(bytes);
                      updateStock[0].image = img64;

                    }

                    if (selectStock[0].code.toString() != productCodeController.text) {
                      if (selectStock[0].code != 0) {
                        updateStock[0].code = productCodeController.text;
                      }
                    }
                    updateStock[0].amount = finalAmount.toString();
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
  //Actual body start
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              '재고 추가/소진',
            ),
            centerTitle: true, //툴바 타이틀 가운데정렬
          ),
          body: Container(
              // width: double.infinity,
              margin: const EdgeInsets.fromLTRB(60, 30, 60, 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('재고 사진을 수정하려면'),
                      const Text('아래 사진을 클릭해주세요.'),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height * 0.42,
                          height: MediaQuery.of(context).size.height * 0.42,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: _isBeforeImage,
                                      child: selectStock[0]
                                              .image!.toString() == '' //IF DB DOESN'T HAVE IMAGE
                                          ? Image.asset(
                                              // SHOW TAKOYAKI
                                              'assets/image/no_stock_image.jpg',
                                            )
                                          : SizedBox(
                                              // IF HAVE IMAGE
                                              width : MediaQuery.of(context).size.height * 0.4,
                                              height: MediaQuery.of(context).size.height * 0.4,
                                              child: Image.memory(
                                                  // SHOW ITS IMAGE
                                                  Base64Decoder().convert(selectStock[0].image!)),
                                            ),
                                    ),
                                    Visibility(
                                        visible: _isAfterImage,
                                        child: _imageFile == null
                                            ? Image.memory(
                                           Base64Decoder().convert(selectStock[0].image!)/* FileImage(File(
                                                      selectStock[0].image!))*/
                                                  //as ImageProvider
                                        )
                                              : Image(image: FileImage(
                                                  File(_imageFile.path)),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                        Text(selectStock[0].name!, style: Theme.of(context).textTheme.bodyText1,),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextField(
                              style: !_codeIsEnable ? TextStyle(color: Colors.grey,) : TextStyle(color: Colors.black),

                              decoration: InputDecoration(
                                  enabled: _codeIsEnable,
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)),
                                  labelText: '상품코드',
                                  labelStyle: !_codeIsEnable ? TextStyle(color: Colors.grey) : TextStyle(color: Colors.black)
                              ),
                              controller: productCodeController,
                            ),
                          ),
                          IconButton(onPressed: () => scanBarcodeNormal(), icon: Icon(Icons.qr_code_scanner_rounded)),

                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          Checkbox(value: _codeChecked, onChanged: (value) {
                            setState(() {
                              _codeChecked = value!;
                              _codeIsEnable = value;
                            });
                          },
                          ),
                          Text('직접 입력'),

                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('추가/소진할 수량을 입력해주세요.',),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                '현재 수량  :  ${selectStock[0].amount}',
                              // widget.unit
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:65,
                                  height:45,
                                  child: TextField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'(^\d*\.?\d*)')),
                                    ],
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black)),
                                      labelText: '수량',
                                      labelStyle: TextStyle(color: Colors.black),
                                    ),
                                    controller: productAmountController,
                                  ),
                                ),
                                Text('  ${selectStock[0].unit!}') ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          editProductState('추가');
                        },
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.black,
                          // onSurface: Colors.grey,
                          fixedSize: const Size(100, 50),
                        ),
                        // backgroundColor: Colors.black),
                        child: const Text('추 가',
                          style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          editProductState('소진');
                        },
                        // => editProductState('소진'),
                        style: TextButton.styleFrom(
                          //     primary: Colors.black,
                          //     onSurface: Colors.grey,
                          fixedSize: const Size(100, 50),
                        ),
                        //     backgroundColor: Colors.black),
                        child: const Text(
                          '소 진',
                          style: TextStyle(
                              //fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
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
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 30);
    setState(() {
      _isBeforeImage = false;
      _isAfterImage = true;
      _imageFile = pickedFile;
    });
  }

}
