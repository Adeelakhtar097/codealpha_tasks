import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Clear All Data?', style: TextStyle(color: Colors.red)),
        content: const Text(
          'This action is permanent and cannot be undone. All logged activities and tracking progress will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              final provider = Provider.of<ActivityProvider>(context, listen: false);
              provider.clearAllData().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to clear data: $e'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Appearance
            _buildSectionHeader(context, 'Appearance'),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle between dark and light themes'),
                  value: themeProvider.isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    themeProvider.toggleTheme();
                  },
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            const Divider(),

            // Section 2: Goals
            _buildSectionHeader(context, 'Goals'),
            ListTile(
              leading: const Icon(Icons.directions_walk, color: Colors.green),
              title: const Text('Daily Step Goal'),
              trailing: Text(
                '10,000 steps',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_fire_department, color: AppColors.accent),
              title: const Text('Daily Calorie Goal'),
              trailing: Text(
                '600 kcal',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: AppColors.accentBlue),
              title: const Text('Daily Duration Goal'),
              trailing: Text(
                '60 min',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
            const Divider(),

            // Section 3: Data Management
            _buildSectionHeader(context, 'Data Management'),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Reset the database and remove all history'),
              onTap: () => _showClearDataDialog(context),
            ),
            const Divider(),

            // Section 4: About
            _buildSectionHeader(context, 'About'),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppColors.primary),
              title: const Text('Fitness Tracker App'),
              subtitle: const Text('Version 1.0.0'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
