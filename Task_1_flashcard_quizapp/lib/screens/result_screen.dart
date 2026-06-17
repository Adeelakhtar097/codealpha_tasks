import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flashcard_model.dart';
import '../utils/constants.dart';
import 'package:gap/gap.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  String _getMotivationalMessage(double percentage) {
    if (percentage >= 90) return 'Excellent Work! 🎉';
    if (percentage >= 70) return 'Great Job! Keep it up! 👍';
    if (percentage >= 50) return 'Good Effort, Practice More! 💪';
    return 'Keep Practicing! You Got This! 📚';
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 70) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    
    final int correct = args['correct'] as int;
    final int incorrect = args['incorrect'] as int;
    final int total = args['total'] as int;
    final List<FlashcardModel> cards = args['cards'] as List<FlashcardModel>;

    final double percentage = total > 0 ? (correct / total) * 100 : 0.0;
    final String message = _getMotivationalMessage(percentage);
    final Color scoreColor = _getScoreColor(percentage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        automaticallyImplyLeading: false, // Prevent swiping back to the quiz
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Circular Score Indicator
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: total > 0 ? correct / total : 0,
                        strokeWidth: 12,
                        backgroundColor: theme.dividerColor,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          'Score',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),

              const Gap(32),

              // Motivational message
              Text(
                message,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),

              const Gap(8),

              // Score fraction text
              Text(
                '$correct / $total Correct',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyMedium?.color?.withAlpha(200),
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms),

              const Gap(32),

              // Stats Row Cards
              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard(
                      theme,
                      title: 'Correct',
                      value: correct.toString(),
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _buildDetailCard(
                      theme,
                      title: 'Incorrect',
                      value: incorrect.toString(),
                      color: Colors.red,
                      icon: Icons.highlight_off,
                    ),
                  ),
                ],
              )
              .animate()
              .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
              .fadeIn(delay: 400.ms),

              const Spacer(),

              // Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Re-push QuizScreen with the exact same cards list
                        Navigator.pushReplacementNamed(
                          context,
                          AppConstants.routeQuiz,
                          arguments: cards,
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Go Home'),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    ThemeData theme, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const Gap(8),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(2),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
