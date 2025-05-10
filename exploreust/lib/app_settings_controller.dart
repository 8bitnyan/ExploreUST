import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  String _timeFormat = '24h'; // '12h' or '24h'

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  String get timeFormat => _timeFormat;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void setLocale(Locale? locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void setTimeFormat(String format) {
    if (_timeFormat != format) {
      _timeFormat = format;
      notifyListeners();
    }
  }
}
