import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/address.dart';

class DBHelper {
  static const _databaseName = "database.db";
  static const _databaseVersion = 1;
  static const table = 'address';
  static const columnName = 'address';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database as Database;
    _database = await _initDatabase();
    return _database as Database;
  }

  _initDatabase() async {
  io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, _databaseName);
  return await openDatabase(path,
      version: _databaseVersion,
      onCreate: _onCreate);

  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $columnName VARCHAR(255) NOT NULL
          )
          ''');  
  }

  Future<bool> insert(Map<String, dynamic> data) async {
  
    final Database db = await database;
    final int res = await db.insert(table, data);
    if (res != 0) {
      return true;
    } else {
      return false;
    }
  }

  //Delete a street from the DB
  Future<bool> delete(int id) async {
    Database db = await DBHelper.instance.database;
    final int res = await db.delete(table, where: 'id = ?', whereArgs: [id]);
    if (res != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(int id,Map<String, dynamic> value) async {
    Database db = await DBHelper.instance.database;
    final int res = await db.update(table, value, where: 'id = ?', whereArgs: [id]);
    if (res != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Address>> getAddresses() async {
    Database db = await DBHelper.instance.database;
    List<Map<String, dynamic>> res = await db.query(table, columns: ['id',columnName]);
    List<Address> list = [];
    for (var i in res){
        list.add(Address.fromJson(i));
    }
    return list;
  }

}
