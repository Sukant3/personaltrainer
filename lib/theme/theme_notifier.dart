import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static final ThemeNotifier instance = ThemeNotifier._internal();
  static const String _themeKey = 'selectedThemeMode';

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  ThemeNotifier._internal() {
    _themeMode = ThemeMode.system; // default theme
  }

  // Load saved theme
  static Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      instance._themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  // Update theme
  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
  }
}

// Global singleton
final themeNotifier = ThemeNotifier.instance;
