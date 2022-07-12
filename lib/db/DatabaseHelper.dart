import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Stock.dart';

import 'dart:async';

class DatabaseHelper {
  static final _databaseName = "stock.db";
  static final _databaseVersion =1;
  static final table = 'stock';

  static final columnname = 'name';
  static final columnamount = 'amount';
  static final columnunit = 'unit';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();


  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async{
    await db.execute('''
    create table $table(
    $columnname TEXT PRIMARY KEY,
    $columnamount TEXT,
    $columnunit TEXT)
    ''');
  }

  Future<int> insert(Stock stock) async {
    Database db = await instance.database;
    var res = await db.insert(table, stock.toMap());
    return res;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var res = await db.query(table, orderBy: "$columnname DESC");
    return res;
  }

  Future<int> delete(String name) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnname = ?', whereArgs: [name]);
  }

  Future<List<Map<String, Object?>>> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }

}