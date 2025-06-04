import 'package:flutter/material.dart';
import 'package:tmdb_flutter/app/data/local/app_settings_local_data_source.dart';

class LocalizationProvider extends ChangeNotifier {
  LocalizationProvider(this._appSettingsLocalDataSource) {
    _loadLocale();
  }

  final AppSettingsLocalDataSource _appSettingsLocalDataSource;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> _loadLocale() async {
    final savedLocale = await _appSettingsLocalDataSource.getLocale();
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);
    await _appSettingsLocalDataSource.saveLocale(languageCode);
    notifyListeners();
  }
} 