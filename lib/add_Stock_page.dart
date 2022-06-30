import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class add_Stock_page extends StatefulWidget {
  const add_Stock_page({Key? key}) : super(key: key);

  @override
  State<add_Stock_page> createState() => _add_Stock_pageState();
}

class _add_Stock_pageState extends State<add_Stock_page> {
  final _unitValue = ['EA', 'kg', 'g', 'L', 'ml', 'cm', 'm', 'oz'];
  var _selectedValue = 'EA';
  final productNameController = TextEditingController();
  final productAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    void showToast(String message) {
      Fluttertoast.showToast(msg: message + '을 입력해주세요.',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    }

    void addProductDialog() {
      var name = productNameController.text;
      var amount = double.parse(productAmountController.text);
      if (name == "") {
        showToast('품목명');
        //TODO Toast외않됌?
      } else if (amount.toString() == "") {
        showToast('수량');
      } else {
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
                    Text("추가할 품목을 확인하세요."),
                  ],
                ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '품목명 : ' + name + '\n수량 : ' + amount.toString() + ' (' +
                          _selectedValue + ')\n추가하시겠습니까?',
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
                    onPressed: () { //TODO DB(내부저장소든 뭐든)에 추가하는 코드
                      Navigator.pop(context);
                    },
                    child: const Text("확인"),
                  ),
                ],
              );
            });
      }
    }



    return Scaffold(
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
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      onSurface: Colors.grey,
                      backgroundColor: Colors.grey),
                  child: const Icon(Icons.add),
                ),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: Icon(Icons.add, size: 200),
                //   label: Text('이미지 추가'),
                //   style: TextButton.styleFrom(
                //     // padding: EdgeInsets.all(30),
                //     minimumSize: Size(70.0, 70.0),
                //       onSurface: Colors.grey, backgroundColor: Colors.grey),
                // ),
              ),
              TextField(
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    labelText: '품목명',
                    labelStyle: TextStyle(color: Colors.black)
                ),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      labelText: '수량',
                      labelStyle: TextStyle(color: Colors.black)
                    ),
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
            SizedBox(
              width: double.infinity,
                child: TextButton(
                    onPressed: () => addProductDialog()
                    ,
                    style: TextButton.styleFrom(
                        primary: Colors.black,
                        onSurface: Colors.grey,
                        backgroundColor: Colors.grey),
                    child: const Text('추가하기')))
          ],
        ),
      ),
    );
  }
}
