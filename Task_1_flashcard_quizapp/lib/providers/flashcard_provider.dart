import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../services/hive_service.dart';
import '../utils/constants.dart';
import '../utils/sample_data.dart';

class FlashcardProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<FlashcardModel> _allCards = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  
  bool _isDarkMode = false;
  bool _shuffleMode = false;
  bool _showCategory = true;

  // Getters
  List<FlashcardModel> get allCards => _allCards;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  
  bool get isDarkMode => _isDarkMode;
  bool get shuffleMode => _shuffleMode;
  bool get showCategory => _showCategory;

  List<FlashcardModel> get filteredCards {
    List<FlashcardModel> cards = List.from(_allCards);
    
    // Apply Category Filter
    if (_selectedCategory != 'All') {
      cards = cards.where((card) => card.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }
    
    // Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      cards = cards
          .where((card) => card.question.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                           card.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    
    // Apply Shuffle Mode if requested
    if (_shuffleMode) {
      // Return a shuffled copy
      cards.shuffle();
    }
    
    return cards;
  }

  List<FlashcardModel> get favoriteCards =>
      _allCards.where((card) => card.isFavorite).toList();

  List<FlashcardModel> get learnedCards =>
      _allCards.where((card) => card.isLearned).toList();

  int get totalCount => _allCards.length;
  int get favoriteCount => favoriteCards.length;
  int get learnedCount => learnedCards.length;

  // Methods
  Future<void> loadCards() async {
    try {
      _allCards = _hiveService.getAllCards();
      
      // Load Settings
      _isDarkMode = _hiveService.getSetting(AppConstants.keyDarkMode, defaultValue: false);
      _shuffleMode = _hiveService.getSetting(AppConstants.keyShuffleMode, defaultValue: false);
      _showCategory = _hiveService.getSetting(AppConstants.keyShowCategory, defaultValue: true);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cards: $e');
    }
  }

  Future<void> addCard(FlashcardModel card) async {
    try {
      await _hiveService.addCard(card);
      _allCards.add(card);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  Future<void> updateCard(FlashcardModel card) async {
    try {
      await _hiveService.updateCard(card);
      final index = _allCards.indexWhere((element) => element.id == card.id);
      if (index != -1) {
        _allCards[index] = card;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }

  Future<void> deleteCard(String id) async {
    try {
      await _hiveService.deleteCard(id);
      _allCards.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting card: $e');
      rethrow;
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    try {
      final index = _allCards.indexWhere((element) => element.id == id);
      if (index != -1) {
        final card = _allCards[index];
        card.isFavorite = !card.isFavorite;
        await _hiveService.updateCard(card);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  Future<void> toggleLearned(String id) async {
    try {
      final index = _allCards.indexWhere((element) => element.id == id);
      if (index != -1) {
        final card = _allCards[index];
        card.isLearned = !card.isLearned;
        await _hiveService.updateCard(card);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling learned: $e');
    }
  }

  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode = !_isDarkMode;
      await _hiveService.saveSetting(AppConstants.keyDarkMode, _isDarkMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling dark mode: $e');
    }
  }

  Future<void> toggleShuffleMode() async {
    try {
      _shuffleMode = !_shuffleMode;
      await _hiveService.saveSetting(AppConstants.keyShuffleMode, _shuffleMode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling shuffle mode: $e');
    }
  }

  Future<void> toggleShowCategory() async {
    try {
      _showCategory = !_showCategory;
      await _hiveService.saveSetting(AppConstants.keyShowCategory, _showCategory);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling show category: $e');
    }
  }

  Future<void> resetAllCards() async {
    try {
      await _hiveService.clearAll();
      _allCards.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting cards: $e');
      rethrow;
    }
  }

  Future<void> loadSampleData() async {
    try {
      // Clear current list first
      await _hiveService.clearAll();
      _allCards.clear();

      // Load sample data
      final sampleCards = SampleData.sampleFlashcards;
      for (final card in sampleCards) {
        await _hiveService.addCard(card);
        _allCards.add(card);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading sample data: $e');
      rethrow;
    }
  }
}
