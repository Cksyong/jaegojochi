import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Stock.dart';
import 'dart:io' as io;
import 'dart:async';

class DetailDBHelper {
  static const SECRET_KEY = "2021_PRIVATE_KEY_ENCRYPT_2021";
  static const DATABASE_VERSION = 1;

  List<Stock> tables =[];

  static const _databaseName = "stock.db";
  static const table = 'stock';

  static const columnname = 'name';
  static const columnamount = 'amount';
  static const columnunit = 'unit';
  static const columnimage = 'image';
  static const columncode = 'code';

  DetailDBHelper._privateConstructor();
  static final DetailDBHelper instance = DetailDBHelper._privateConstructor();

  static Database? db;
  Future<Database> get database async => db ??= await _initDatabase();

//FROM HERE
  Future<Database> _initDatabase() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print(path);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute("create table $table($columnname TEXT PRIMARY KEY,$columnamount TEXT, $columnunit TEXT, $columnimage BLOB, $columncode TEXT)");
  }
  //TO HERE INITIALIZED DATABASE FOR START

  //CRUD - CREATE
  Future<int> insert(Stock stock) async {
    Database db = await instance.database;
    var res = await db.insert(table, stock.toMap());
    return res;
  }

  //CRUD - READ
  Future<List<Stock>> getStocks() async{
    Database db = await instance.database;
    List<Map<String,dynamic>>? maps = await db.query(table, columns: [columnname,columnamount,columnunit,columnimage,columncode]);
    List<Stock> stocks = [];
    if(maps.isNotEmpty ){
      for(int i=0; i<maps.length; i++) {
        stocks.add(Stock.fromMap(maps[i]));
        tables.add(Stock.fromMap(maps[i]));
      }
    }
    return stocks;
  }

  //CRUD - UPDATE
  Future<int> update(Stock stock) async {
    Database db = await instance.database;
    return await db.update(table, stock.toMap(), where: '$columnname = ?', whereArgs: [stock.name]);
  }

  //CRUD - DELETE
  Future<int> delete(String name) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnname = ?', whereArgs: [name]);
  }

  // FOR stock_Detail_Info, send selected stock
  Future<List<Stock>> getSelectStock(String name) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table, where: 'name = ?',
      whereArgs: [name]
    );
    return List.generate(maps.length, (i) {
      return Stock(name: maps[i]['name'], amount: maps[i]['amount'], unit: maps[i]['unit'], image: maps[i]['image'], code: maps[i]['code']);
    });
  }

  Future<List<Stock>> getSelectStockFromCode(String code) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
        table, where: 'code = ?',
        whereArgs: [code]
    );
    return List.generate(maps.length, (i) {
      return Stock(name: maps[i]['name'], amount: maps[i]['amount'], unit: maps[i]['unit'], image: maps[i]['image'], code: maps[i]['code']);
    });
  }

  //CRUD - ADVANCED DELETE -> DELETE EVERYTHING
  Future<List<Map<String, Object?>>> clearTable() async {
    Database db = await instance.database;
    return await db.rawQuery("DELETE FROM $table");
  }
}