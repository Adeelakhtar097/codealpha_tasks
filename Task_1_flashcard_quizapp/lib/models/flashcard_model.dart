import 'package:hive/hive.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 0)
class FlashcardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String question;

  @HiveField(2)
  String answer;

  @HiveField(3)
  String category;

  @HiveField(4)
  String difficulty; // 'easy' | 'medium' | 'hard'

  @HiveField(5)
  bool isFavorite;

  @HiveField(6)
  bool isLearned;

  @HiveField(7)
  final DateTime createdDate;

  @HiveField(8)
  DateTime? lastReviewedDate;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.difficulty,
    this.isFavorite = false,
    this.isLearned = false,
    required this.createdDate,
    this.lastReviewedDate,
  });

  FlashcardModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    String? difficulty,
    bool? isFavorite,
    bool? isLearned,
    DateTime? createdDate,
    DateTime? lastReviewedDate,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
      isLearned: isLearned ?? this.isLearned,
      createdDate: createdDate ?? this.createdDate,
      lastReviewedDate: lastReviewedDate ?? this.lastReviewedDate,
    );
  }
}
