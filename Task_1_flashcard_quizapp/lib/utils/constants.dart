class AppConstants {
  // Routes
  static const String routeSplash = '/';
  static const String routeHome = '/home';
  static const String routeAdd = '/add';
  static const String routeEdit = '/edit';
  static const String routeStudy = '/study';
  static const String routeQuiz = '/quiz';
  static const String routeResult = '/result';
  static const String routeSettings = '/settings';

  // Hive
  static const String flashcardsBox = 'flashcards';
  static const String settingsBox = 'settings';

  // Settings Keys
  static const String keyDarkMode = 'isDarkMode';
  static const String keyShuffleMode = 'shuffleMode';
  static const String keyShowCategory = 'showCategory';

  // Categories
  static const List<String> categories = [
    'All',
    'Science',
    'Math',
    'Programming',
    'English',
    'History',
    'General',
  ];

  static List<String> get formCategories => categories.where((cat) => cat != 'All').toList();

  // Difficulties
  static const String difficultyEasy = 'easy';
  static const String difficultyMedium = 'medium';
  static const String difficultyHard = 'hard';

  // Text constants
  static const String appName = 'FlashCard Pro';
  static const String splashSubtitle = 'Study Smarter, Not Harder';
  static const String emptyStateTitle = 'No flashcards yet';
  static const String emptyStateSubtitle = 'Tap + to add your first card';
}
