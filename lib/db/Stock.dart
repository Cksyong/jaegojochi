class Stock{
  String name;
  int amount;
  String unit;

  Stock({
    required this.name,
    required this.amount,
    required this.unit,
  });

  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'amount' : amount,
      'unit' : unit,
    };
  }
}


