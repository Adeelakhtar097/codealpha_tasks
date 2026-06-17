import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/flashcard_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_chip_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/flashcard_tile.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<FlashcardProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<FlashcardProvider>(context);
    final filteredCards = provider.filteredCards;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.routeSettings);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Total',
                    value: provider.totalCount.toString(),
                    icon: Icons.style_outlined,
                    iconColor: theme.colorScheme.primary,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Favorites',
                    value: provider.favoriteCount.toString(),
                    icon: Icons.favorite,
                    iconColor: Colors.redAccent,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Learned',
                    value: provider.learnedCount.toString(),
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search flashcards...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          const Gap(16),

          // Horizontal Categories
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.categories[index];
                final isSelected = provider.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CategoryChipWidget(
                    label: category,
                    isSelected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        provider.setCategory(category);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Gap(16),

          // Flashcards List
          Expanded(
            child: filteredCards.isEmpty
                ? EmptyStateWidget(
                    onAddPressed: () {
                      Navigator.pushNamed(context, AppConstants.routeAdd);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      final card = filteredCards[index];
                      return FlashcardTile(
                        card: card,
                        onTap: () {
                          // Open in Study Mode starting at this index
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeStudy,
                            arguments: {
                              'cards': filteredCards,
                              'initialIndex': index,
                            },
                          );
                        },
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            AppConstants.routeEdit,
                            arguments: card,
                          );
                        },
                      )
                      .animate()
                      .fadeIn(duration: 350.ms, delay: (index * 50).ms)
                      .slideY(begin: 0.1, end: 0, duration: 350.ms, curve: Curves.easeOut);
                    },
                  ),
          ),

          // Bottom buttons
          if (filteredCards.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.routeStudy,
                          arguments: {
                            'cards': filteredCards,
                            'initialIndex': 0,
                          },
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Study Mode'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppConstants.routeQuiz,
                          arguments: filteredCards,
                        );
                      },
                      icon: const Icon(Icons.quiz),
                      label: const Text('Quiz Mode'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.routeAdd);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const Gap(4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withAlpha(180),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
