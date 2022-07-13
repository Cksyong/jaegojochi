import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Stock.dart';
import 'dart:io' as io;
import 'dart:async';

class DatabaseHelper {
  static const _databaseName = "stock.db";
  static const table = 'stock';

  static const columnname = 'name';
  static const columnamount = 'amount';
  static const columnunit = 'unit';
  static const columnimage = 'image';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? db;
  Future<Database> get database async => db ??= await _initDatabase();


  Future<Database> _initDatabase() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute("create table stock($columnname TEXT PRIMARY KEY,$columnamount TEXT, $columnunit TEXT, $columnimage BLOB)");
  }

  Future<int> insert(Stock stock) async {
    Database db = await instance.database;
    var res = await db.insert('stock', stock.toMap());
    return res;
  }

  Future<List<Stock>> getStocks() async{
    Database db = await instance.database;
    List<Map<String,dynamic>>? maps = await db.query(table, columns: [columnname,columnamount,columnunit,columnimage]);
    List<Stock> stocks = [];
    if(maps.isNotEmpty ){
      for(int i=0; i<maps.length; i++) {
        stocks.add(Stock.fromMap(maps[i]));
      }
    }
    return stocks;
  }

  //
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   var res = await db.query(table, orderBy: "$columnname DESC");
  //   return res;
  // }

  Future<int> delete(String name) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnname = ?', whereArgs: [name]);
  }

  Future<List<Stock>> getSelectStock(String name) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table, where: 'name = ?',
      whereArgs: [name]
    );

    return List.generate(maps.length, (i) {
      return Stock(name: maps[i]['name'], amount: maps[i]['amount'], unit: maps[i]['unit'], image: maps[i]['image']);
    });
  }
  //
  // Future<List<Map<String, Object?>>> clearTable() async {
  //   Database db = await instance.database;
  //   return await db.rawQuery("DELETE FROM $table");
  // }
  //
  // Future close() async{
  //   Database db = await instance.database;
  //   db.close();
  // }

}