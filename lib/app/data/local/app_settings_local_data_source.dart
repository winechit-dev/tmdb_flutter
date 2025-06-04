import 'package:sqflite/sqflite.dart';
import 'package:tmdb_flutter/app/data/local/database_helper.dart';

class AppSettingsLocalDataSource {
  AppSettingsLocalDataSource(this._databaseHelper);

  final DatabaseHelper _databaseHelper;
  static const String _localeKey = 'locale';

  Future<void> saveLocale(String languageCode) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'app_settings',
      {
        'key': _localeKey,
        'value': languageCode,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getLocale() async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [_localeKey],
    );
    if (result.isEmpty) return null;
    return result.first['value']! as String;
  }
}
