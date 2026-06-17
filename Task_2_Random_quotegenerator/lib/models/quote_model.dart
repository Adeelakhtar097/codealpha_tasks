class QuoteModel {
  final int id;
  final String quoteText;
  final String authorName;
  final String category;

  const QuoteModel({
    required this.id,
    required this.quoteText,
    required this.authorName,
    required this.category,
  });

  /// Convert to a Map for JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quoteText': quoteText,
      'authorName': authorName,
      'category': category,
    };
  }

  /// Recreate QuoteModel from a Map.
  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    return QuoteModel(
      id: map['id'] as int,
      quoteText: map['quoteText'] as String,
      authorName: map['authorName'] as String,
      category: map['category'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuoteModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
