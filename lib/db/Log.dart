
class LogData {
  String? date;
  String? up;
  String? down;
  String? total;

  LogData({this.date, this.up, this.down, this.total});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'date': date,
      'up': up,
      'down': down,
      'total' : total,
    };
    return map;
  }

  LogData.fromMap(Map<String, dynamic> map){
    date = map['date'];
    up = map['up'];
    down = map['down'];
    total = map['total'];
  }


}