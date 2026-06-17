import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class FlashcardTile extends StatelessWidget {
  final FlashcardModel card;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const FlashcardTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.onEdit,
  });

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
    final theme = Theme.of(context);
    final provider = Provider.of<FlashcardProvider>(context, listen: false);

    return Dismissible(
      key: Key(card.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Flashcard'),
            content: const Text('Are you sure you want to delete this flashcard?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        provider.deleteCard(card.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Flashcard deleted successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        card.question,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        card.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: card.isFavorite ? Colors.red : theme.hintColor,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(card.id);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Chips Row
                    Row(
                      children: [
                        // Category Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? AppTheme.primary.withAlpha(25)
                                : AppTheme.primary.withAlpha(40),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primary.withAlpha(80),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            card.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Difficulty Chip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(card.difficulty).withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _getDifficultyColor(card.difficulty).withAlpha(80),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            card.difficulty[0].toUpperCase() + card.difficulty.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getDifficultyColor(card.difficulty),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Action Buttons Row
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: onEdit,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            Icons.check_circle,
                            size: 20,
                            color: card.isLearned ? Colors.green : theme.hintColor.withAlpha(80),
                          ),
                          onPressed: () {
                            provider.toggleLearned(card.id);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
