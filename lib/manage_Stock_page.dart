import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jaegojochi/main.dart';

class manage_Stock_page extends StatefulWidget {
  final String name;
  final String unit;
  final double amount;
  const manage_Stock_page({Key? key, required this.name, required this.unit, required this.amount}) : super(key: key);



  @override
  State<manage_Stock_page> createState() => _manage_Stock_pageState();
}

class _manage_Stock_pageState extends State<manage_Stock_page> {
  @override
  Widget build(BuildContext context) {
    final productAmountController = TextEditingController();

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
      double amount = 0;
      if (productAmountController.text != '') {
        amount = double.parse(productAmountController.text);
      }
      if (amount == 0) {
        _showAlertDialog('', '추가/소진할 수량을 입력해주세요.');
        // } else if (method == '소진' && widget.amount < amount) {
        _showAlertDialog('', '소진할 수량은 현재 수량을 초과할 수 없습니다.');
      } else {
        double finalAmount = 0;
        if (method == '추가') {
          // finalAmount = widget.amount + amount;
        } else if (method == '소진') {
          // finalAmount = widget.amount - amount;
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
                    Text('hi'
                        // '현재 수량 : ${widget.amount} ${widget.unit}'
                        //     '\n변경 수량 : ' + amount.toString() + ' (' +
                        //     widget.unit + ')\n'
                        //     '최종 수량 : ${finalAmount}\n' + method + '하시겠습니까?',
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
        title: const Text('재고 추가/소진',
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
                  '재고명',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Text('재고 사진을 수정하려면 아래 사진을 클릭해주세요.'),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: const EdgeInsets.fromLTRB(80, 5, 80, 10),
                child: OutlinedButton(
                    onPressed: () {},
                    child: Image.asset('assets/image/takoyaki.jpg')),
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: const Text('추가/소진할 수량을 입력해주세요.')),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('현재 수량 ',style: TextStyle(fontSize: 20),
                        // '${widget.amount.toString()} '
                        ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                      child: Text('30', style: TextStyle(fontSize: 20),
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
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^\d*\.?\d*)'))
                            ],
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintText: '수량',
                                hintStyle: TextStyle(fontSize: 17),

                             ),
                            controller: productAmountController,
                          ),
                        ),
                        Text('EA'
                            // widget.unit
                            )
                      ],
                    ),
                  ],
                ),
              ),
               Container(
                 padding: EdgeInsets.only(top: 330),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   ElevatedButton(
                     onPressed: () => editProductState('추가'),
                     style: TextButton.styleFrom(
                         primary: Colors.black,
                         onSurface: Colors.grey,
                         fixedSize: Size(100, 50),
                         backgroundColor: Colors.black),
                     child: const Text(
                       '추 가',
                       style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, color: Colors.white),
                     ),
                   ),
                   ElevatedButton(
                     onPressed: productAmountController.text.isEmpty ? null : (){},
                     // => editProductState('소진'),
                     style: TextButton.styleFrom(
                     //     primary: Colors.black,
                     //     onSurface: Colors.grey,
                         fixedSize: Size(100, 50),),
                     //     backgroundColor: Colors.black),
                     child: const Text(
                       '소 진',
                       style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, color: Colors.white),
                     ),
                   ),
                 ],
               ),
               ),




             ],
          )


      ),

    );
  }
}
