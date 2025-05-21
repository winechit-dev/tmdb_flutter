import 'package:sqflite/sqflite.dart';
import 'package:tmdb_flutter/app/data/local/database_helper.dart';

class FavoriteMoviesLocalDataSource {
  FavoriteMoviesLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  Future<void> addFavoriteMovie(Map<String, dynamic> movie) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'favorite_movies',
      {
        ...movie,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavoriteMovie(int movieId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'favorite_movies',
      where: 'movieId = ?',
      whereArgs: [movieId],
    );
  }

  Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    final db = await _databaseHelper.database;
    return db.query(
      'favorite_movies',
      orderBy: 'createdAt DESC',
    );
  }

  Future<bool> isMovieFavorite(int movieId) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'favorite_movies',
      where: 'movieId = ?',
      whereArgs: [movieId],
    );
    return result.isNotEmpty;
  }
}
