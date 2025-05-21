import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'favorite_movies.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_movies(
        id INTEGER PRIMARY KEY,
        movieId INTEGER NOT NULL,
        title TEXT NOT NULL,
        posterPath TEXT,
        overview TEXT,
        voteAverage REAL,
        releaseDate TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }
}
