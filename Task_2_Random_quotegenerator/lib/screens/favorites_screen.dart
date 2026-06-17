import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/quote_model.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _shareQuote(QuoteModel quote) {
    Share.share('"${quote.quoteText}"\n\n— ${quote.authorName}\n\n#RandomQuoteGenerator');
  }

  Future<void> _copyQuote(BuildContext context, QuoteModel quote) async {
    await Clipboard.setData(ClipboardData(text: '"${quote.quoteText}"\n\n— ${quote.authorName}'));
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
    final cardBgColor = isDark ? AppColors.cardDark : AppColors.cardLight;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: textSecondaryColor,
        ),
      ),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          final favorites = quoteProvider.favorites;

          if (favorites.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 80,
                      color: textSecondaryColor.withOpacity(0.3),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No favorites yet",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the heart icon on any quote to save it here.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textSecondaryColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: favorites.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final quote = favorites[index];
              return Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quote.category.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quote text
                    Text(
                      quote.quoteText,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        color: textPrimaryColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Author name & Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            quote.authorName,
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        // Actions
                        IconButton(
                          icon: Icon(Icons.share_rounded,
                              color: textSecondaryColor, size: 20),
                          onPressed: () => _shareQuote(quote),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(Icons.copy_rounded,
                              color: textSecondaryColor, size: 20),
                          onPressed: () => _copyQuote(context, quote),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.favorite_rounded,
                              color: AppColors.accent, size: 22),
                          onPressed: () {
                            quoteProvider.toggleFavorite(quote);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: (index * 60).ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    delay: (index * 60).ms,
                    curve: Curves.easeOut,
                  );
            },
          );
        },
      ),
    );
  }
}
