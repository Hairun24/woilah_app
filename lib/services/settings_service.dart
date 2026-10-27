import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  static const String _keyTheme = 'theme_mode';
  static const String _keyAdult = 'adult_content_enabled';
  static const String _keyNotifications = 'notifications_enabled';

  ThemeMode _themeMode = ThemeMode.system;
  bool _adultContentEnabled = false;
  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get adultContentEnabled => _adultContentEnabled;
  bool get notificationsEnabled => _notificationsEnabled;

  SettingsService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    final themeValue = prefs.getString(_keyTheme);
    if (themeValue == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeValue == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    _adultContentEnabled = prefs.getBool(_keyAdult) ?? false;
    _notificationsEnabled = prefs.getBool(_keyNotifications) ?? true;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode value) async {
    _themeMode = value;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyTheme,
      value == ThemeMode.light
          ? 'light'
          : value == ThemeMode.dark
              ? 'dark'
              : 'system',
    );

    notifyListeners();
  }

  Future<void> setAdultContentEnabled(bool value) async {
    _adultContentEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAdult, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
    notifyListeners();
  }
}
