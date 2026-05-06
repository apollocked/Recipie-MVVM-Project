import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  static const String _themeKey = "theme_mode";

  ThemeProvider() {
    _loadTheme();
  }

  void setTheme(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveTheme(mode);
  }

  void toggleTheme() async {
    _themeMode = (_themeMode == ThemeMode.dark)
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
    await _saveTheme(_themeMode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString(_themeKey);

    if (themeName != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}
