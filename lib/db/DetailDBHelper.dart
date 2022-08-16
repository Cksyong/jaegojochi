// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:io' as io;
// import 'dart:async';
// import 'Log.dart';
//
// class DetailDBHelper {
//   static const SECRET_KEY = "2022_PRIVATE_KEY_ENCRYPT_2022";
//   static const DATABASE_VERSION = 1;
//
//   List<Log> tables = [];
//
//   static const _databaseName2 = "Log.db";
//   static const table2 = 'log';
//
//   static const columndate = 'date';
//   static const columnup = 'up';
//   static const columndown = 'down';
//   static const columntotal = 'total';
//
//   DetailDBHelper._privateConstructor2();
//
//   static final DetailDBHelper instance = DetailDBHelper._privateConstructor2();
//
//   static Database? db2;
//
//   Future<Database> get database async => db2 ??= await _initDatabase2();
//
// // FROM HERE
//   Future<Database> _initDatabase2() async{
//     io.Directory documentsDirectory2 = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory2.path, _databaseName2);
//     var db = await openDatabase(path, version: 1, onCreate: _openLog);
//     print(path);
//     return db;
//   }
//
//   _openLog(Database db, int version) async{
//     await db.execute(
//         "create table $table2($columndate TEXT, $columnup TEXT, $columndown TEXT, $columntotal TEXT,)");
//   }
//  //클로즈 14:08
//   //TO HERE INITIALIZED DATABASE FOR START
//
//   //CRUD - CREATE
//   Future<int> insert(Log log) async {
//     Database db = await instance.database;
//     var res = await db.insert(table2, log.toMap());
//     return res;
//   }
//
//   //CRUD - READ
//   Future<List<Log>> getLog() async{
//     Database db = await instance.database;
//     List<Map<String,dynamic>>? maps = await db.query(table2, columns: [
//       columndate,columnup,columndown,columntotal]);
//     List<Log> log = [];
//     if(maps.isNotEmpty ){
//       for(int i=0; i<maps.length; i++) {
//         log.add(Log.fromMap(maps[i]));
//         tables.add(Log.fromMap(maps[i]));
//       }
//     }
//     return log;
//   }
//
//   // CRUD - UPDATE
//   Future<int> update(Log log) async {
//     Database db = await instance.database;
//     return await db.update(table2, log.toMap(),
//         where: '$columndate = ?', whereArgs: [log.date]);
//   }
//
//   // CRUD - DELETE
//   Future<int> delete(String name) async {
//     Database db = await instance.database;
//     return await db.delete(table2, where: '$columndate = ?', whereArgs: [name]);
//   }
//
//   // FOR stock_Detail_Info, send selected stock
//   Future<List<Log>> getSelectLog(String name) async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps =
//       await db.query(table2, where: 'name = ?', whereArgs: [name]);
//     return List.generate(maps.length, (i) {
//       return Log(
//           date: maps[i]['date'],
//           up: maps[i]['up'],
//           down: maps[i]['down'],
//           total: maps[i]['total']);
//     });
//   }
//
//
//   //CRUD - ADVANCED DELETE -> DELETE EVERYTHING
//   Future<List<Map<String, Object?>>> clearTable() async {
//     Database db = await instance.database;
//     return await db.rawQuery("DELETE FROM $table2");
//   }
// }
