import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';
import '../widgets/flip_card_widget.dart';
import 'package:gap/gap.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  List<FlashcardModel> _studyCards = [];
  int _currentIndex = 0;
  bool _isFront = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final List<FlashcardModel> cards = args['cards'] as List<FlashcardModel>;
      final int initialIndex = args['initialIndex'] as int;
      
      _studyCards = List.from(cards);
      _currentIndex = initialIndex;
      _initialized = true;
    }
  }

  void _nextCard() {
    if (_currentIndex < _studyCards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFront = true;
      });
    }
  }

  void _previousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFront = true;
      });
    }
  }

  void _toggleFlip() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _shuffleCards() {
    setState(() {
      _studyCards.shuffle();
      _currentIndex = 0;
      _isFront = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cards shuffled!'),
        duration: Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case AppConstants.difficultyEasy:
        return Colors.green;
      case AppConstants.difficultyMedium:
        return Colors.orange;
      case AppConstants.difficultyHard:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_studyCards.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No cards to study.'),
        ),
      );
    }

    final theme = Theme.of(context);
    final provider = Provider.of<FlashcardProvider>(context);
    
    // Find the latest card state from provider to keep favorite/learned states up-to-date
    final currentCardInList = _studyCards[_currentIndex];
    final cardId = currentCardInList.id;
    
    // Attempt to locate in provider's live list
    final liveCardIndex = provider.allCards.indexWhere((c) => c.id == cardId);
    final card = liveCardIndex != -1 ? provider.allCards[liveCardIndex] : currentCardInList;

    final progress = (_currentIndex + 1) / _studyCards.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Study Mode (${_currentIndex + 1}/${_studyCards.length})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              minHeight: 6,
            ),
            
            const Gap(24),

            // Card Container with gesture detector for swipes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 380,
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity == null) return;
                        if (details.primaryVelocity! < 0) {
                          _nextCard(); // Swipe Left -> Next
                        } else if (details.primaryVelocity! > 0) {
                          _previousCard(); // Swipe Right -> Previous
                        }
                      },
                      child: FlipCardWidget(
                        isFront: _isFront,
                        onTap: _toggleFlip,
                        front: _buildCardFace(
                          theme,
                          title: provider.showCategory ? card.category.toUpperCase() : 'FLASHCARD',
                          content: card.question,
                          isFront: true,
                          difficulty: card.difficulty,
                        ),
                        back: _buildCardFace(
                          theme,
                          title: 'ANSWER',
                          content: card.answer,
                          isFront: false,
                          difficulty: card.difficulty,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Gap(16),

            // Toggle show answer button
            TextButton(
              onPressed: _toggleFlip,
              child: Text(
                _isFront ? 'Show Answer' : 'Hide Answer',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const Gap(8),

            // Navigation Row: Left, center index, right
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: _currentIndex > 0 ? _previousCard : null,
                  ),
                  Text(
                    '${_currentIndex + 1} of ${_studyCards.length}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: _currentIndex < _studyCards.length - 1 ? _nextCard : null,
                  ),
                ],
              ),
            ),

            const Gap(24),

            // Action Row: Favorite, Learned, Shuffle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                border: Border(
                  top: BorderSide(color: theme.dividerColor, width: 1.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Favorite
                  IconButton(
                    icon: Icon(
                      card.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: card.isFavorite ? Colors.red : theme.iconTheme.color,
                      size: 28,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(card.id);
                    },
                  ),
                  // Mark as Learned
                  IconButton(
                    icon: Icon(
                      card.isLearned ? Icons.check_circle : Icons.check_circle_outline,
                      color: card.isLearned ? Colors.green : theme.iconTheme.color,
                      size: 28,
                    ),
                    onPressed: () {
                      provider.toggleLearned(card.id);
                    },
                  ),
                  // Shuffle
                  IconButton(
                    icon: const Icon(
                      Icons.shuffle,
                      size: 28,
                    ),
                    onPressed: _shuffleCards,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFace(
    ThemeData theme, {
    required String title,
    required String content,
    required bool isFront,
    required String difficulty,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (isFront)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(difficulty).withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _getDifficultyColor(difficulty).withAlpha(80), width: 1),
                    ),
                    child: Text(
                      difficulty.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(difficulty),
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            // Center text
            SingleChildScrollView(
              child: Text(
                content,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            // Flip Hint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flip_camera_android_rounded,
                  size: 14,
                  color: theme.hintColor.withAlpha(150),
                ),
                const SizedBox(width: 4),
                Text(
                  'TAP TO FLIP',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: theme.hintColor.withAlpha(150),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
