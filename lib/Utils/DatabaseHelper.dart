import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  //TODO: PASS "DATABASE_NAME.db"
  String _databaseName = "carwasher.db";
  int _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) {
    //TODO: CREATE TABLE QUERY
    db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, user_id TEXT, user_name TEXT, user_mobile TEXT, user_email TEXT, user_password TEXT)");
  }

  Future<int> insertUser(String user_id, String user_name, String user_mobile, String user_email, String user_password) async{
    //TODO: RAW INSERT QUERY
    Database db = await instance.database;
    return db.rawInsert("INSERT INTO user(user_id, user_name, user_mobile, user_email, user_password) VALUES('$user_id', '$user_name', '$user_mobile', '$user_email', '$user_password')");
  }

  Future<int> getCount() async {
    Database db = await instance.database;
    var x = await db.rawQuery('SELECT COUNT (*) from user');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List> getUser() async{
    Database db = await instance.database;
    return db.rawQuery("SELECT * FROM user");
  }
}	//class DatabaseHelper close