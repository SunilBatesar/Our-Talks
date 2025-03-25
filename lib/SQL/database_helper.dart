import 'package:flutter/material.dart';
import 'package:ourtalks/view_model/Models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static String friendsTable = "friends";

  static String userIDKey = "userID";
  static String nameKey = "name";
  static String userNameKey = "userName";
  static String dpKey = "userDP";
  static String emailKey = "email";
  static String benerKey = "banner";

  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), "my_database.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// FRIENDS TABLE NOTIFICATION
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $friendsTable (
      $userIDKey TEXT PRIMARY KEY,
      $nameKey TEXT,
      $userNameKey TEXT,
      $dpKey TEXT,
      $emailKey TEXT,
      $benerKey TEXT,
      FOREIGN KEY ($userIDKey) REFERENCES users(id) ON DELETE CASCADE
    )
    ''',
    );
  }

  Future<void> insertFriend(UserModel model) async {
    final db = await _instance.database;
    await db.insert(friendsTable, model.tomapLocalStore(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserModel>> getFriends() async {
    final db = await _instance.database;
    final List<Map<String, dynamic>> maps = await db.query('friends');
    return maps.map((e) => UserModel.fromJson(e, e[userIDKey])).toList();
  }

  Future<void> updateFriend(UserModel model) async {
    final db = await _instance.database;
    await db.update(friendsTable, model.tomapLocalStore(),
        where: '$userIDKey = ?', whereArgs: [model.userID]);
  }

  Future<void> deleteFriend(String id) async {
    final db = await _instance.database;
    await db.delete(friendsTable, where: '$userIDKey = ?', whereArgs: [id]);
  }

  Future<void> clearFriendsTable() async {
    final db = await _instance.database;
    await db.delete(friendsTable);
  }

  Future<bool> checkTableExists(String tableName) async {
    final db = await DatabaseHelper().database;
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [tableName]);
    return result.isNotEmpty;
  }

  Future<void> deleteOldDatabase() async {
    String path = join(await getDatabasesPath(), "my_database.db");
    await deleteDatabase(path);
    _database = null;
    debugPrint("Old database deleted successfully!");
  }
}
