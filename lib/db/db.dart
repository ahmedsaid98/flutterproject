import 'package:coronavirus/models/day_read.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';

class DB {
  DB._();
  static final DB db = DB._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    
    _database = await initDB();
    return _database;
  }

  final id = 'id';
  final date = 'date';
  final confirmed = 'confirmed';
  final dailyCases = 'dailyCases';
  final recovered = 'recovered';
  final deaths = 'deaths';

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE $egyptDbTable(
              $id INTEGER PRIMARY KEY,
              $date TEXT,
              $confirmed TEXT,
              $dailyCases TEXT,
              $recovered TEXT,
              $deaths TEXT)
            ''');
        await db.execute('''
            CREATE TABLE $americaDbTable(
              $id INTEGER PRIMARY KEY,
              $date TEXT,
              $confirmed TEXT,
              $dailyCases TEXT,
              $recovered TEXT,
              $deaths TEXT)
            ''');
        await db.execute('''
            CREATE TABLE $italyDbTable(
              $id INTEGER PRIMARY KEY,
              $date TEXT,
              $confirmed TEXT,
              $dailyCases TEXT,
              $recovered TEXT,
              $deaths TEXT)
            ''');
        await db.execute('''
            CREATE TABLE $chinaDbTable(
              $id INTEGER PRIMARY KEY,
              $date TEXT,
              $confirmed TEXT,
              $dailyCases TEXT,
              $recovered TEXT,
              $deaths TEXT,
              
              )

            ''');
      },
    );
  }

  

  insertData(DayRead data, String tableName) async {
    final db = await database;
    var res = await db.insert(tableName, data.toMap());
    return res;
  }

  

  Future<List<DayRead>> getAllData(String tableName) async {
    final db = await database;
    var res = await db.query(tableName);
    List<DayRead> list =
        res.isNotEmpty ? res.map((c) => DayRead.fromMap(c)).toList() : [];
    return list;
  }

 

  updateData(DayRead data, String tableName) async {
    final db = await database;
    var res = await db
        .update(tableName, data.toMap(), where: "id = ?", whereArgs: [data.id]);
    return res;
  }


  deleteData(int id, String tableName) async {
    final db = await database;
    db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }

 

  getSingleData(String tableName) async {
    final db = await database;
    var result = await db.query(tableName, orderBy: 'id DESC', limit: 1);
    return (result.isNotEmpty) ? result : null;
  }
}
