import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/quote_model.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(_onTextChanged);

    // Reset search on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<QuoteProvider>().search('');
      }
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

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
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textSecondaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: TextField(
          controller: _textController,
          autofocus: true,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: textPrimaryColor,
          ),
          decoration: InputDecoration(
            hintText: "Search for quotes or authors...",
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: textSecondaryColor.withOpacity(0.7),
            ),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            context.read<QuoteProvider>().search(val);
          },
        ),
        actions: [
          if (_textController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_rounded, color: textSecondaryColor),
              onPressed: () {
                _textController.clear();
                context.read<QuoteProvider>().search('');
              },
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: Consumer<QuoteProvider>(
        builder: (context, quoteProvider, child) {
          final query = _textController.text.trim();
          final filtered = quoteProvider.filteredQuotes;

          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 80,
                    color: textSecondaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Search for quotes or authors",
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

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied_rounded,
                    size: 80,
                    color: textSecondaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No results found",
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

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final quote = filtered[index];
              final isFav = quoteProvider.isFavorite(quote);

              return Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top: Category and Favorite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share_rounded,
                                  color: textSecondaryColor, size: 18),
                              onPressed: () => _shareQuote(quote),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: Icon(Icons.copy_rounded,
                                  color: textSecondaryColor, size: 18),
                              onPressed: () => _copyQuote(context, quote),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? AppColors.accent : textSecondaryColor,
                                size: 20,
                              ),
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
                    const SizedBox(height: 12),

                    // Quote Text
                    Text(
                      quote.quoteText,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        color: textPrimaryColor,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Author
                    Text(
                      "— ${quote.authorName}",
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 350.ms,
                    delay: (index * 40).ms,
                    curve: Curves.easeOut,
                  )
                  .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 350.ms,
                    delay: (index * 40).ms,
                    curve: Curves.easeOut,
                  );
            },
          );
        },
      ),
    );
  }
}
