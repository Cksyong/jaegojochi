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

    void editProductState(String method) {
      var amount = double.parse(productAmountController.text);
      if (amount.toString() == "") {
        //showToast('수량');
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
                    Text("수량을 확인하세요."),
                  ],
                ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '\n수량 : ' + amount.toString() + ' (' +
                          widget.unit + ')\n' + method + '하시겠습니까?',
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
        title: const Text('재고 추가/소진'),
        centerTitle: true, //툴바 타이틀 가운데정렬
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
          margin: const EdgeInsets.only(top: 70.0, left: 50.0, right: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.name, style: TextStyle(fontSize: 20),),
              const Text('재고 사진을 수정하려면 아래 사진을 클릭해주세요.'),
              OutlinedButton(
                  onPressed: () {},
                  child: Image.asset('assets/image/takoyaki.jpg')),
              const Text('추가/소진할 수량을 입력해주세요.'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                    const Text('현재 수량 : '),
                    Text('${widget.amount.toString()} '),
                  Text(widget.unit)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 60,
                    height: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  Text(widget.unit)
                ],
              ),
              SizedBox(
                width: double.infinity,
                child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () => editProductState('추가'),
                            style: TextButton.styleFrom(
                                primary: Colors.black,
                                onSurface: Colors.grey,
                                backgroundColor: Colors.grey
                            ),
                            child: const Text('추가', style: TextStyle(color: Colors.white),),
                          ),
                        TextButton(
                            onPressed: () => editProductState('소진'),
                            style: TextButton.styleFrom(
                                primary: Colors.black,
                                onSurface: Colors.grey,
                                backgroundColor: Colors.grey),
                            child: const Text('소진', style: TextStyle(color: Colors.white),),
                          ),
                      ],
                    ),
              )
            ],
          )),
    );
  }
}
