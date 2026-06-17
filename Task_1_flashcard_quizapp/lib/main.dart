import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/flashcard_model.dart';
import 'providers/flashcard_provider.dart';
import 'screens/add_edit_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/study_screen.dart';
import 'services/hive_service.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive storage service
  final hiveService = HiveService();
  await hiveService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FlashcardProvider(),
      child: const FlashCardApp(),
    ),
  );
}

class FlashCardApp extends StatelessWidget {
  const FlashCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashcardProvider>(context);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppConstants.routeSplash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppConstants.routeSplash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );
          case AppConstants.routeHome:
            return MaterialPageRoute(
              builder: (_) => const HomeScreen(),
              settings: settings,
            );
          case AppConstants.routeAdd:
            return MaterialPageRoute(
              builder: (_) => const AddEditScreen(),
              settings: settings,
            );
          case AppConstants.routeEdit:
            final card = settings.arguments as FlashcardModel?;
            return MaterialPageRoute(
              builder: (_) => AddEditScreen(card: card),
              settings: settings,
            );
          case AppConstants.routeStudy:
            return MaterialPageRoute(
              builder: (_) => const StudyScreen(),
              settings: settings,
            );
          case AppConstants.routeQuiz:
            return MaterialPageRoute(
              builder: (_) => const QuizScreen(),
              settings: settings,
            );
          case AppConstants.routeResult:
            return MaterialPageRoute(
              builder: (_) => const ResultScreen(),
              settings: settings,
            );
          case AppConstants.routeSettings:
            return MaterialPageRoute(
              builder: (_) => const SettingsScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
