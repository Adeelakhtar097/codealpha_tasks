import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quote_model.dart';
import '../utils/theme.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBgColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final Color textPrimaryColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color iconColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.10),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category Badge & Heart Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quote.category.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: isFavorite
                      ? const Icon(
                          Icons.favorite_rounded,
                          key: ValueKey('filled'),
                          color: AppColors.accent,
                          size: 28,
                        )
                      : Icon(
                          Icons.favorite_border_rounded,
                          key: ValueKey('outline'),
                          color: iconColor,
                          size: 28,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Opening Quotation Mark
          Text(
            '“',
            style: GoogleFonts.playfairDisplay(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: AppColors.primary.withOpacity(0.25),
              height: 0.6,
            ),
          ),

          // Quote Text
          Text(
            quote.quoteText,
            style: GoogleFonts.playfairDisplay(
              color: textPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Author Row
          Row(
            children: [
              Container(
                width: 32,
                height: 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  quote.authorName,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
