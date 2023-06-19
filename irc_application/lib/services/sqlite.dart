import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modelsSqlite/fileCsvScanModel.dart';

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

  Future<void> writeTableData_ScanCheck({FileCsvScanModel? model}) async {
    try {
      Database db = await DatabaseHelper().database;
      Map<String, dynamic> row = {
        'LOCATION': model?.LOCATION,
        'USER': model?.USER,
        'B1': model?.B1,
        'B2': model?.B2,
        'B3': model?.B3,
        'B4': model?.B4,
        'TIME': model?.TIME,
        'DATE': model?.DATE,
      };
      int id = await db.insert('FileScanCsv', row);
      print('Data written to SQLite with id: $id');
    } catch (e) {
      print('Error writing to SQLite: $e');
    }
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
    _createFileScanCsv(db, newVersion);
  }

  void _createFileCsv(Database db, int newVersion) async {
    await db.execute('CREATE TABLE FileCsv ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'LOCATION TEXT,'
        'DATA TEXT'
        ')');
  }

  void _createFileScanCsv(Database db, int newVersion) async {
    await db.execute('CREATE TABLE FileScanCsv ('
        'ID INTEGER PRIMARY KEY AUTOINCREMENT, '
        'LOCATION TEXT,'
        'USER TEXT,'
        'BARCODE TEXT ,'
        'B1 TEXT,'
        'B2 TEXT,'
        'B3 TEXT,'
        'B4 TEXT,'
        'TIME TEXT,'
        'DATE TEXT'
        ')');
  }
}
