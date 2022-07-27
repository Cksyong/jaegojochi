class Stock {
  String? name;
  String? amount;
  String? unit;
  String? image;
  String? code;

  Stock({this.name, this.amount, this.unit, this.image, this.code});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'name': name,
      'amount': amount,
      'unit': unit,
      'image' : image,
      'code' : code
    };
    return map;
  }

  Stock.fromMap(Map<String, dynamic> map){
    name = map['name'];
    amount = map['amount'];
    unit = map['unit'];
    image = map['image'];
    code = map['code'];
  }


}