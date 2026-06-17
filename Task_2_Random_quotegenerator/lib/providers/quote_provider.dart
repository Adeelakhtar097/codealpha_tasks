import 'dart:math';
import 'package:flutter/material.dart';
import '../database/local_storage.dart';
import '../models/quote_model.dart';
import '../services/quote_service.dart';

class QuoteProvider with ChangeNotifier {
  List<QuoteModel> _quotes = [];
  List<QuoteModel> _filteredQuotes = [];
  List<QuoteModel> _favorites = [];
  QuoteModel? _currentQuote;
  int? _lastQuoteId;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  // Getters
  List<QuoteModel> get quotes => _quotes;
  List<QuoteModel> get filteredQuotes => _filteredQuotes;
  List<QuoteModel> get favorites => _favorites;
  QuoteModel? get currentQuote => _currentQuote;
  int? get lastQuoteId => _lastQuoteId;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  QuoteProvider() {
    _init();
  }

  /// Load quotes and favorite state on startup.
  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await LocalStorage.getFavorites();
      _quotes = QuoteService.getAllQuotes();
      _applyFilters();
      nextQuote(forceNotify: false);
    } catch (_) {
      // Gracefully handle any startup exceptions
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Apply active filters (category and search query) to update `_filteredQuotes`.
  void _applyFilters() {
    List<QuoteModel> temp = _quotes;

    // Filter by Category
    if (_selectedCategory != 'All') {
      temp = temp
          .where((q) => q.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by Search Query
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      temp = temp.where((q) {
        return q.quoteText.toLowerCase().contains(query) ||
            q.authorName.toLowerCase().contains(query) ||
            q.category.toLowerCase().contains(query);
      }).toList();
    }

    _filteredQuotes = temp;
  }

  /// Choose a new random quote from the filtered collection, preventing consecutive duplicates.
  void nextQuote({bool forceNotify = true}) {
    if (_filteredQuotes.isEmpty) {
      _currentQuote = null;
      if (forceNotify) notifyListeners();
      return;
    }

    if (_filteredQuotes.length == 1) {
      _currentQuote = _filteredQuotes.first;
      _lastQuoteId = _currentQuote?.id;
      if (forceNotify) notifyListeners();
      return;
    }

    // Exclude the last shown quote to prevent consecutive repeats
    final candidates = _filteredQuotes.where((q) => q.id != _lastQuoteId).toList();
    final random = Random();

    if (candidates.isNotEmpty) {
      _currentQuote = candidates[random.nextInt(candidates.length)];
    } else {
      _currentQuote = _filteredQuotes[random.nextInt(_filteredQuotes.length)];
    }

    _lastQuoteId = _currentQuote?.id;

    if (forceNotify) notifyListeners();
  }

  /// Set the current category, update filtered lists, and select a new quote.
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    nextQuote(forceNotify: false);
    notifyListeners();
  }

  /// Update search query, apply filters, and select a new quote.
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    nextQuote(forceNotify: false);
    notifyListeners();
  }

  /// Check if a specific quote is currently in the favorites list.
  bool isFavorite(QuoteModel quote) {
    return _favorites.any((q) => q.id == quote.id);
  }

  /// Toggle the favorite status of a quote and write update to SharedPreferences.
  Future<void> toggleFavorite(QuoteModel quote) async {
    final alreadyFavorite = isFavorite(quote);
    if (alreadyFavorite) {
      _favorites.removeWhere((q) => q.id == quote.id);
      notifyListeners();
      await LocalStorage.removeFavorite(quote.id);
    } else {
      _favorites.add(quote);
      notifyListeners();
      await LocalStorage.saveFavorite(quote);
    }
  }
}
