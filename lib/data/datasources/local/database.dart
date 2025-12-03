import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() {
    return _instance;
  }

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'smart_tourism.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phoneNumber TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE destinations (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        rating REAL NOT NULL,
        location TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        destinationId TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        numberOfGuests INTEGER NOT NULL,
        totalPrice REAL NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}