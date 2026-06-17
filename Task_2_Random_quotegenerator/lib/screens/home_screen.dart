import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/quote_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_button.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'All',
    'Motivation',
    'Success',
    'Education',
    'Life',
    'Happiness',
    'Programming',
    'Funny',
    'Wisdom',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.value = 1.0; // Initially fully visible
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Perform reverse animation, update quote state, and perform forward animation.
  void _transitionQuote(VoidCallback updateState) {
    _animationController.reverse().then((_) {
      if (mounted) {
        updateState();
        _animationController.forward();
      }
    });
  }

  void _shareQuote(String quoteText, String authorName) {
    Share.share('"$quoteText"\n\n— $authorName\n\n#RandomQuoteGenerator');
  }

  Future<void> _copyQuote(BuildContext context, String quoteText, String authorName) async {
    await Clipboard.setData(ClipboardData(text: '"$quoteText"\n\n— $authorName'));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Quote copied successfully",
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final textPrimaryColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.format_quote_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Daily Quotes",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: textSecondaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_rounded, color: textSecondaryColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  color: textSecondaryColor,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          if (quoteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final currentQuote = quoteProvider.currentQuote;

          if (currentQuote == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied_rounded,
                    size: 56,
                    color: textSecondaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No quotes available.",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inspire yourself",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "A new perspective, every tap.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textSecondaryColor,
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .slideX(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOut),

                const SizedBox(height: 24),

                // Category chips row
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = quoteProvider.selectedCategory == category;
                      return CategoryChip(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          if (!isSelected) {
                            _transitionQuote(() {
                              quoteProvider.setCategory(category);
                            });
                          }
                        },
                      );
                    },
                  ),
                ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

                const SizedBox(height: 28),

                // Quote Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: QuoteCard(
                    quote: currentQuote,
                    isFavorite: quoteProvider.isFavorite(currentQuote),
                    onFavorite: () {
                      quoteProvider.toggleFavorite(currentQuote);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // Action Buttons Row (Share / Copy)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: "Share",
                        icon: Icons.share_rounded,
                        outlined: true,
                        onPressed: () => _shareQuote(
                          currentQuote.quoteText,
                          currentQuote.authorName,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        label: "Copy",
                        icon: Icons.copy_rounded,
                        outlined: true,
                        onPressed: () => _copyQuote(
                          context,
                          currentQuote.quoteText,
                          currentQuote.authorName,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // New Quote Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: "New Quote",
                    icon: Icons.auto_awesome_rounded,
                    onPressed: () {
                      _transitionQuote(() {
                        quoteProvider.nextQuote();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
