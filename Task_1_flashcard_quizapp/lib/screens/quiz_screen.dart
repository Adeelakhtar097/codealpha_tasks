import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flashcard_model.dart';
import '../utils/constants.dart';
import 'package:gap/gap.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<FlashcardModel> _quizCards = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;
  bool _showAnswer = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as List<FlashcardModel>;
      _quizCards = List.from(args);
      _quizCards.shuffle(); // Shuffle quiz cards automatically for dynamic flow
      _initialized = true;
    }
  }

  void _handleAnswerResponse(bool isCorrect) {
    if (isCorrect) {
      _correctCount++;
    } else {
      _incorrectCount++;
    }

    if (_currentIndex < _quizCards.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      // Completed last card, navigate to ResultScreen
      Navigator.pushReplacementNamed(
        context,
        AppConstants.routeResult,
        arguments: {
          'correct': _correctCount,
          'incorrect': _incorrectCount,
          'total': _quizCards.length,
          'cards': _quizCards,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCards.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No cards for quiz.'),
        ),
      );
    }

    final theme = Theme.of(context);
    final currentCard = _quizCards[_currentIndex];
    final progress = (_currentIndex + 1) / _quizCards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Mode (Score: $_correctCount/$_currentIndex)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top progress indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 6,
            ),
            
            const Gap(16),

            // Progress text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Card ${_currentIndex + 1} of ${_quizCards.length}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${(progress * 100).toInt()}% Done',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  children: [
                    // Question Card
                    Card(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 180),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentCard.category.toUpperCase(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Gap(12),
                            Text(
                              currentCard.question,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Gap(16),

                    // Answer Widget (slides in when tapped)
                    if (_showAnswer)
                      Card(
                        key: ValueKey('answer_${currentCard.id}'),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 160),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'ANSWER',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Gap(12),
                              Text(
                                currentCard.answer,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut)
                      .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),

            // Bottom control buttons
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 1.5),
                ),
              ),
              child: _showAnswer
                  ? Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _handleAnswerResponse(false),
                            icon: const Icon(Icons.close),
                            label: const Text('Incorrect'),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _handleAnswerResponse(true),
                            icon: const Icon(Icons.check),
                            label: const Text('Correct'),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = true;
                          });
                        },
                        child: const Text('Show Answer'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
