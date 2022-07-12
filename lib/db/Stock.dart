import 'dart:typed_data';

class Stock{
  String name;
  String amount;
  String unit;
  Uint8List image;

  Stock({
    required this.name,
    required this.amount,
    required this.unit,
    required this.image
  });

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'amount' : amount,
      'unit' : unit,
      'image' : image
    };
  }
}


