import 'package:flutter/material.dart';
import '../database/local_storage.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load dark mode setting from local storage.
  Future<void> _loadTheme() async {
    final savedTheme = await LocalStorage.getTheme();
    if (savedTheme != null) {
      _isDarkMode = savedTheme;
      notifyListeners();
    }
  }

  /// Toggle between light and dark modes and persist the preference.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await LocalStorage.saveTheme(_isDarkMode);
  }
}
