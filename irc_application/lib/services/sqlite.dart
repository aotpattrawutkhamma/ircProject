import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'my_database.db');
    bool isDatabaseExists = await databaseExists(dbPath);
    if (isDatabaseExists) {
      print("Database already exists");
    } else {
      var database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: _createDb,
      );

      return database;
    }
    return await openDatabase(dbPath);
  }

  Future<int> insertSqlite(String tableName, Map<String, dynamic> row) async {
    Database db = await this.database;

    print("WriteData  ${tableName}");
    return await db.insert(tableName, row);
  }

  Future<int> deleted(String tableName) async {
    Database db = await this.database;

    print("Deleted  ${tableName}");
    return await db.delete(tableName);
  }

  Future<List<Map<String, dynamic>>> queryData(String tableName) async {
    Database db = await this.database;
    print("Query ${tableName}");
    return await db.query(tableName);
  }

  Future<int> deletedRowSqlite(
      {String? tableName, String? columnName, dynamic? columnValue}) async {
    Database db = await this.database;

    print("DeleteRow Sucess ${tableName}");

    return await db
        .delete(tableName!, where: '$columnName = ?', whereArgs: [columnValue]);
  }

  void _createDb(Database db, int newVersion) async {
    _createFileCsv(db, newVersion);
  }

  void _createFileCsv(Database db, int newVersion) async {
    await db.execute('CREATE TABLE FileCsv ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'LOCATION TEXT,'
        'DATA TEXT'
        ')');
  }
}
