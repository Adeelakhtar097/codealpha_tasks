import 'package:hive_flutter/hive_flutter.dart';
import '../models/flashcard_model.dart';
import '../utils/constants.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box<FlashcardModel> _flashcardBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FlashcardModelAdapter());
    }

    _flashcardBox = await Hive.openBox<FlashcardModel>(AppConstants.flashcardsBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  Future<void> addCard(FlashcardModel card) async {
    try {
      await _flashcardBox.put(card.id, card);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCard(FlashcardModel card) async {
    try {
      await _flashcardBox.put(card.id, card);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCard(String id) async {
    try {
      await _flashcardBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  List<FlashcardModel> getAllCards() {
    return _flashcardBox.values.toList();
  }

  Future<void> clearAll() async {
    try {
      await _flashcardBox.clear();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox.put(key, value);
    } catch (e) {
      rethrow;
    }
  }

  dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }
}
