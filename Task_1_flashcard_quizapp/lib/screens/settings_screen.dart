import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showResetDialog(BuildContext context, FlashcardProvider provider, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset All Cards'),
        content: const Text(
          'Are you sure you want to delete all flashcards? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(dialogContext).pop();
              try {
                await provider.resetAllCards();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('All cards deleted successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Error resetting cards'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, FlashcardProvider provider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restore Sample Data'),
        content: const Text(
          'This will delete all current cards and restore the 4 default sample flashcards. Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.of(dialogContext).pop();
              try {
                await provider.loadSampleData();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Sample cards loaded successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Error loading sample data'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<FlashcardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        children: [
          // Appearance
          _buildSectionHeader(theme, 'Appearance'),
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              value: provider.isDarkMode,
              onChanged: (value) {
                provider.toggleDarkMode();
              },
            ),
          ),

          // Study Preferences
          _buildSectionHeader(theme, 'Study Preferences'),
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.shuffle_rounded),
                  title: const Text('Shuffle Cards'),
                  subtitle: const Text('Randomize card sequence in study mode'),
                  value: provider.shuffleMode,
                  onChanged: (value) {
                    provider.toggleShuffleMode();
                  },
                ),
                Divider(height: 1, color: theme.dividerColor, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.label_outline_rounded),
                  title: const Text('Show Category'),
                  subtitle: const Text('Display categories above question text'),
                  value: provider.showCategory,
                  onChanged: (value) {
                    provider.toggleShowCategory();
                  },
                ),
              ],
            ),
          ),

          // Data Management
          _buildSectionHeader(theme, 'Data Management'),
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.delete_forever_outlined, color: theme.colorScheme.error),
                  title: Text(
                    'Reset All Cards',
                    style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Permanently clear all local flashcards'),
                  onTap: () => _showResetDialog(context, provider, theme),
                ),
                Divider(height: 1, color: theme.dividerColor, indent: 56),
                ListTile(
                  leading: Icon(Icons.restore_rounded, color: theme.colorScheme.primary),
                  title: const Text('Restore Sample Data'),
                  subtitle: const Text('Re-initialize with default flashcards'),
                  onTap: () => _showRestoreDialog(context, provider),
                ),
              ],
            ),
          ),

          // About
          _buildSectionHeader(theme, 'About'),
          Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('App Name'),
                  trailing: Text(
                    AppConstants.appName,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor, indent: 56),
                ListTile(
                  leading: const Icon(Icons.code_rounded),
                  title: const Text('Version'),
                  trailing: Text(
                    '1.0.0',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor, indent: 56),
                ListTile(
                  leading: const Icon(Icons.person_outline_rounded),
                  title: const Text('Developer'),
                  trailing: Text(
                    'FlashCard Pro Team',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
