import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Map<int, String> scripts = {
  1: ''' CREATE TABLE imcList (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          imc TEXT
          );'''
};

class SQLiteDataBase {
  static Database? db;

  Future<Database> getDataBase() async {
    if (db == null) {
      return await startDatabase();
    } else {
      return db!;
    }
  }

  Future<Database> startDatabase() async {
    var db =
        await openDatabase(path.join(await getDatabasesPath(), 'database.db'), version: scripts.length, onCreate: (Database db, int version) async {
      for (var i = 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        debugPrint(scripts[i]!);
      }
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion + 1; i <= scripts.length; i++) {
        await db.execute(scripts[i]!);
        debugPrint(scripts[i]!);
      }
    });
    return db;
  }
}
