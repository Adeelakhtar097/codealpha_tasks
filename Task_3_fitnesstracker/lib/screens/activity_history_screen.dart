import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';
import 'add_activity_screen.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          // Sync local controller with provider search query if provider clears it
          if (provider.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
            _searchController.clear();
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    provider.searchActivities(val);
                  },
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by exercise type or notes...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.clearFilter();
                            },
                          )
                        : null,
                  ),
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: AppConstants.filterOptions.map((type) {
                    final isSelected = provider.selectedFilter == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _searchController.clear();
                            provider.filterByType(type);
                          }
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark
                            ? AppColors.surfaceDark
                            : Colors.grey.withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.15),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Activities List
              Expanded(
                child: _buildListContent(provider, isDark, theme),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListContent(ActivityProvider provider, bool isDark, ThemeData theme) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.filteredActivities.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_run,
                size: 64,
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              Text(
                'No matching activities found.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _searchController.text.isNotEmpty || provider.selectedFilter != 'All'
                    ? 'Try adjusting your search query or filter.'
                    : 'Get started by logging your first fitness activity!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (_searchController.text.isNotEmpty || provider.selectedFilter != 'All')
                ElevatedButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    provider.clearFilter();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Filters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim, secAnim) => const AddActivityScreen(),
                        transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                          opacity: anim,
                          child: child,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Log Activity'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: provider.filteredActivities.length,
      itemBuilder: (context, index) {
        return ActivityCard(
          activity: provider.filteredActivities[index],
          index: index,
        );
      },
    );
  }
}
