import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/flashcard_model.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';
import 'package:gap/gap.dart';

class AddEditScreen extends StatefulWidget {
  final FlashcardModel? card;

  const AddEditScreen({super.key, this.card});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _question;
  late String _answer;
  late String _category;
  late String _difficulty;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing
    _question = widget.card?.question ?? '';
    _answer = widget.card?.answer ?? '';
    _category = widget.card?.category ?? AppConstants.formCategories.first;
    _difficulty = widget.card?.difficulty ?? AppConstants.difficultyEasy;
    _isFavorite = widget.card?.isFavorite ?? false;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final provider = Provider.of<FlashcardProvider>(context, listen: false);
      final isEditMode = widget.card != null;

      try {
        if (isEditMode) {
          final updatedCard = widget.card!.copyWith(
            question: _question,
            answer: _answer,
            category: _category,
            difficulty: _difficulty,
            isFavorite: _isFavorite,
            lastReviewedDate: widget.card!.lastReviewedDate,
          );
          provider.updateCard(updatedCard);
          _showSnackBar('Flashcard updated successfully!', Colors.green);
        } else {
          final newCard = FlashcardModel(
            id: const Uuid().v4(),
            question: _question,
            answer: _answer,
            category: _category,
            difficulty: _difficulty,
            isFavorite: _isFavorite,
            createdDate: DateTime.now(),
          );
          provider.addCard(newCard);
          _showSnackBar('Flashcard added successfully!', Colors.green);
        }

        Navigator.of(context).pop();
      } catch (e) {
        _showSnackBar('An error occurred. Please try again.', Colors.redAccent);
      }
    } else {
      _showSnackBar('Please correct the errors in the form.', Colors.orange);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
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
    final isEditMode = widget.card != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Flashcard' : 'Add Flashcard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question field
                Text(
                  'Question',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                TextFormField(
                  initialValue: _question,
                  maxLines: 5,
                  minLines: 2,
                  maxLength: 250,
                  decoration: const InputDecoration(
                    hintText: 'Enter question text...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Question is required';
                    }
                    if (value.trim().length < 5) {
                      return 'Question must be at least 5 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _question = value!.trim(),
                ),

                const Gap(20),

                // Answer field
                Text(
                  'Answer',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                TextFormField(
                  initialValue: _answer,
                  maxLines: 5,
                  minLines: 2,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText: 'Enter answer explanation...',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Answer is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Answer must be at least 3 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _answer = value!.trim(),
                ),

                const Gap(20),

                // Category selection
                Text(
                  'Category',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: AppConstants.formCategories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),

                const Gap(20),

                // Difficulty selection
                Text(
                  'Difficulty',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDifficultyChip(AppConstants.difficultyEasy, 'Easy'),
                    _buildDifficultyChip(AppConstants.difficultyMedium, 'Medium'),
                    _buildDifficultyChip(AppConstants.difficultyHard, 'Hard'),
                  ],
                ),

                const Gap(24),

                // Favorite switch
                Card(
                  margin: EdgeInsets.zero,
                  child: SwitchListTile(
                    title: const Text(
                      'Mark as Favorite',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Add to favorites list on dashboard'),
                    value: _isFavorite,
                    onChanged: (bool value) {
                      setState(() {
                        _isFavorite = value;
                      });
                    },
                  ),
                ),

                const Gap(32),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text(isEditMode ? 'Update Flashcard' : 'Save Flashcard'),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficultyValue, String label) {
    final theme = Theme.of(context);
    final isSelected = _difficulty == difficultyValue;
    final color = _getDifficultyColor(difficultyValue);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: () {
            setState(() {
              _difficulty = difficultyValue;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color.withAlpha(35) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? color : theme.dividerColor,
                width: isSelected ? 2.0 : 1.5,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? color : theme.textTheme.bodyMedium?.color?.withAlpha(180),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
