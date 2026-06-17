import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

class LocalStorage {
  static const String _favoritesKey = 'favorites_quotes';
  static const String _themeKey = 'theme_is_dark';

  // Private constructor to prevent instantiation
  LocalStorage._();

  /// Retrieve the list of favorite quotes.
  static Future<List<QuoteModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favoritesJson = prefs.getStringList(_favoritesKey);
    if (favoritesJson == null) return [];

    try {
      return favoritesJson.map((item) {
        final Map<String, dynamic> map = jsonDecode(item) as Map<String, dynamic>;
        return QuoteModel.fromMap(map);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  /// Add a quote to the favorites list.
  static Future<void> saveFavorite(QuoteModel quote) async {
    final prefs = await SharedPreferences.getInstance();
    final List<QuoteModel> favorites = await getFavorites();
    
    if (!favorites.any((q) => q.id == quote.id)) {
      favorites.add(quote);
      final List<String> favoritesJson = favorites
          .map((q) => jsonEncode(q.toMap()))
          .toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    }
  }

  /// Remove a quote from the favorites list.
  static Future<void> removeFavorite(int quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<QuoteModel> favorites = await getFavorites();
    
    favorites.removeWhere((q) => q.id == quoteId);
    final List<String> favoritesJson = favorites
        .map((q) => jsonEncode(q.toMap()))
        .toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  /// Check if a specific quote is in the favorites list.
  static Future<bool> isFavorite(int quoteId) async {
    final List<QuoteModel> favorites = await getFavorites();
    return favorites.any((q) => q.id == quoteId);
  }

  /// Retrieve the saved dark mode theme setting.
  static Future<bool?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey);
  }

  /// Save the dark mode theme setting.
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
