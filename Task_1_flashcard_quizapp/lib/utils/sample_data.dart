import '../models/flashcard_model.dart';
import 'constants.dart';

class SampleData {
  static List<FlashcardModel> get sampleFlashcards => [
        FlashcardModel(
          id: 'sample_1',
          question: 'What is a Flashcard?',
          answer: 'A learning tool with a question on one side and answer on the other, used for quick revision and memorization.',
          category: 'General',
          difficulty: AppConstants.difficultyEasy,
          createdDate: DateTime.now().subtract(const Duration(days: 4)),
        ),
        FlashcardModel(
          id: 'sample_2',
          question: 'What is Active Recall?',
          answer: 'A study technique where you actively stimulate memory during learning, rather than passively reading notes. Flashcards are the best tool for it.',
          category: 'General',
          difficulty: AppConstants.difficultyMedium,
          createdDate: DateTime.now().subtract(const Duration(days: 3)),
        ),
        FlashcardModel(
          id: 'sample_3',
          question: 'What is Spaced Repetition?',
          answer: 'A learning method where you review material at increasing intervals over time to improve long-term memory retention.',
          category: 'General',
          difficulty: AppConstants.difficultyMedium,
          createdDate: DateTime.now().subtract(const Duration(days: 2)),
        ),
        FlashcardModel(
          id: 'sample_4',
          question: 'What is the Leitner System?',
          answer: 'A flashcard study system where correctly answered cards move to longer review intervals, and incorrect ones go back to daily review.',
          category: 'General',
          difficulty: AppConstants.difficultyHard,
          createdDate: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
}
