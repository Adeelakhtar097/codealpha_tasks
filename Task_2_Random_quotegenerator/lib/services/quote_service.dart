import '../models/quote_model.dart';

class QuoteService {
  static final List<QuoteModel> _quotes = [
    // --- Motivation (13 Quotes) ---
    const QuoteModel(
      id: 1,
      quoteText: "The only way to do great work is to love what you do.",
      authorName: "Steve Jobs",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 2,
      quoteText: "The future belongs to those who believe in the beauty of their dreams.",
      authorName: "Eleanor Roosevelt",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 3,
      quoteText: "You must be the change you wish to see in the world.",
      authorName: "Mahatma Gandhi",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 4,
      quoteText: "Believe you can and you're halfway there.",
      authorName: "Theodore Roosevelt",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 5,
      quoteText: "It always seems impossible until it's done.",
      authorName: "Nelson Mandela",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 6,
      quoteText: "Do not wait for the right opportunity: create it.",
      authorName: "George Bernard Shaw",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 7,
      quoteText: "Act as if what you do makes a difference. It does.",
      authorName: "William James",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 8,
      quoteText: "What you get by achieving your goals is not as important as what you become by achieving your goals.",
      authorName: "Zig Ziglar",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 9,
      quoteText: "Do not count the days, make the days count.",
      authorName: "Muhammad Ali",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 10,
      quoteText: "The only limit to our realization of tomorrow will be our doubts of today.",
      authorName: "Franklin D. Roosevelt",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 11,
      quoteText: "Keep your face always toward the sunshine—and shadows will fall behind you.",
      authorName: "Walt Whitman",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 12,
      quoteText: "It is during our darkest moments that we must focus to see the light.",
      authorName: "Aristotle Onassis",
      category: "Motivation",
    ),
    const QuoteModel(
      id: 13,
      quoteText: "You are never too old to set another goal or to dream a new dream.",
      authorName: "C.S. Lewis",
      category: "Motivation",
    ),

    // --- Success (12 Quotes) ---
    const QuoteModel(
      id: 14,
      quoteText: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      authorName: "Winston Churchill",
      category: "Success",
    ),
    const QuoteModel(
      id: 15,
      quoteText: "I have not failed. I've just found 10,000 ways that won't work.",
      authorName: "Thomas A. Edison",
      category: "Success",
    ),
    const QuoteModel(
      id: 16,
      quoteText: "I never dreamed about success. I worked for it.",
      authorName: "Estée Lauder",
      category: "Success",
    ),
    const QuoteModel(
      id: 17,
      quoteText: "Success usually comes to those who are too busy to be looking for it.",
      authorName: "Henry David Thoreau",
      category: "Success",
    ),
    const QuoteModel(
      id: 18,
      quoteText: "The secret of success is to do the common thing uncommonly well.",
      authorName: "John D. Rockefeller Jr.",
      category: "Success",
    ),
    const QuoteModel(
      id: 19,
      quoteText: "Don't be afraid to give up the good to go for the great.",
      authorName: "John D. Rockefeller",
      category: "Success",
    ),
    const QuoteModel(
      id: 20,
      quoteText: "Opportunities don't happen. You create them.",
      authorName: "Chris Grosser",
      category: "Success",
    ),
    const QuoteModel(
      id: 21,
      quoteText: "Success is walking from failure to failure with no loss of enthusiasm.",
      authorName: "Winston Churchill",
      category: "Success",
    ),
    const QuoteModel(
      id: 22,
      quoteText: "The road to success and the road to failure are almost exactly the same.",
      authorName: "Colin R. Davis",
      category: "Success",
    ),
    const QuoteModel(
      id: 23,
      quoteText: "If you really look closely, most overnight successes took a long time.",
      authorName: "Steve Jobs",
      category: "Success",
    ),
    const QuoteModel(
      id: 24,
      quoteText: "Try not to become a man of success. Rather become a man of value.",
      authorName: "Albert Einstein",
      category: "Success",
    ),
    const QuoteModel(
      id: 25,
      quoteText: "There are no secrets to success. It is the result of preparation, hard work, and learning from failure.",
      authorName: "Colin Powell",
      category: "Success",
    ),

    // --- Education (12 Quotes) ---
    const QuoteModel(
      id: 26,
      quoteText: "Education is the most powerful weapon which you can use to change the world.",
      authorName: "Nelson Mandela",
      category: "Education",
    ),
    const QuoteModel(
      id: 27,
      quoteText: "An investment in knowledge pays the best interest.",
      authorName: "Benjamin Franklin",
      category: "Education",
    ),
    const QuoteModel(
      id: 28,
      quoteText: "The beautiful thing about learning is that no one can take it away from you.",
      authorName: "B.B. King",
      category: "Education",
    ),
    const QuoteModel(
      id: 29,
      quoteText: "Live as if you were to die tomorrow. Learn as if you were to live forever.",
      authorName: "Mahatma Gandhi",
      category: "Education",
    ),
    const QuoteModel(
      id: 30,
      quoteText: "Spoon feeding in the long run teaches us nothing but the shape of the spoon.",
      authorName: "E.M. Forster",
      category: "Education",
    ),
    const QuoteModel(
      id: 31,
      quoteText: "The roots of education are bitter, but the fruit is sweet.",
      authorName: "Aristotle",
      category: "Education",
    ),
    const QuoteModel(
      id: 32,
      quoteText: "Change is the end result of all true learning.",
      authorName: "Leo Buscaglia",
      category: "Education",
    ),
    const QuoteModel(
      id: 33,
      quoteText: "The mind is not a vessel to be filled, but a fire to be kindled.",
      authorName: "Plutarch",
      category: "Education",
    ),
    const QuoteModel(
      id: 34,
      quoteText: "Education is not preparation for life; education is life itself.",
      authorName: "John Dewey",
      category: "Education",
    ),
    const QuoteModel(
      id: 35,
      quoteText: "Learning never exhausts the mind.",
      authorName: "Leonardo da Vinci",
      category: "Education",
    ),
    const QuoteModel(
      id: 36,
      quoteText: "The direction in which education starts a man will determine his future in life.",
      authorName: "Plato",
      category: "Education",
    ),
    const QuoteModel(
      id: 37,
      quoteText: "He who opens a school door, closes a prison.",
      authorName: "Victor Hugo",
      category: "Education",
    ),

    // --- Life (12 Quotes) ---
    const QuoteModel(
      id: 38,
      quoteText: "Life is what happens when you're busy making other plans.",
      authorName: "John Lennon",
      category: "Life",
    ),
    const QuoteModel(
      id: 39,
      quoteText: "In the end, it's not the years in your life that count. It's the life in your years.",
      authorName: "Abraham Lincoln",
      category: "Life",
    ),
    const QuoteModel(
      id: 40,
      quoteText: "You only live once, but if you do it right, once is enough.",
      authorName: "Mae West",
      category: "Life",
    ),
    const QuoteModel(
      id: 41,
      quoteText: "Life is either a daring adventure or nothing at all.",
      authorName: "Helen Keller",
      category: "Life",
    ),
    const QuoteModel(
      id: 42,
      quoteText: "Good friends, good books, and a sleepy conscience: this is the ideal life.",
      authorName: "Mark Twain",
      category: "Life",
    ),
    const QuoteModel(
      id: 43,
      quoteText: "Life is really simple, but we insist on making it complicated.",
      authorName: "Confucius",
      category: "Life",
    ),
    const QuoteModel(
      id: 44,
      quoteText: "The purpose of our lives is to be happy.",
      authorName: "Dalai Lama",
      category: "Life",
    ),
    const QuoteModel(
      id: 45,
      quoteText: "Life is 10% what happens to us and 90% how we react to it.",
      authorName: "Charles R. Swindoll",
      category: "Life",
    ),
    const QuoteModel(
      id: 46,
      quoteText: "Get busy living or get busy dying.",
      authorName: "Stephen King",
      category: "Life",
    ),
    const QuoteModel(
      id: 47,
      quoteText: "You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose.",
      authorName: "Dr. Seuss",
      category: "Life",
    ),
    const QuoteModel(
      id: 48,
      quoteText: "To write about life first you must live it.",
      authorName: "Ernest Hemingway",
      category: "Life",
    ),
    const QuoteModel(
      id: 49,
      quoteText: "Sing like no one's listening, love like you've never been hurt, dance like nobody's watching, and live like it's heaven on earth.",
      authorName: "William W. Purkey",
      category: "Life",
    ),

    // --- Happiness (12 Quotes) ---
    const QuoteModel(
      id: 50,
      quoteText: "Happiness is not something ready made. It comes from your own actions.",
      authorName: "Dalai Lama",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 51,
      quoteText: "For every minute you are angry you lose sixty seconds of happiness.",
      authorName: "Ralph Waldo Emerson",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 52,
      quoteText: "The most important thing is to enjoy your life—to be happy—it's all that matters.",
      authorName: "Audrey Hepburn",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 53,
      quoteText: "Happiness depends upon ourselves.",
      authorName: "Aristotle",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 54,
      quoteText: "Sanity and happiness are an impossible combination.",
      authorName: "Mark Twain",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 55,
      quoteText: "Happiness is when what you think, what you say, and what you do are in harmony.",
      authorName: "Mahatma Gandhi",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 56,
      quoteText: "The only way to find true happiness is to risk being completely cut open.",
      authorName: "Chuck Palahniuk",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 57,
      quoteText: "Happiness is a warm puppy.",
      authorName: "Charles M. Schulz",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 58,
      quoteText: "No medicine cures what happiness cannot.",
      authorName: "Gabriel García Márquez",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 59,
      quoteText: "If you want to be happy, be.",
      authorName: "Leo Tolstoy",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 60,
      quoteText: "The secret of happiness is not in doing what one likes, but in liking what one does.",
      authorName: "James M. Barrie",
      category: "Happiness",
    ),
    const QuoteModel(
      id: 61,
      quoteText: "There is only one happiness in this life, to love and be loved.",
      authorName: "George Sand",
      category: "Happiness",
    ),

    // --- Programming (13 Quotes) ---
    const QuoteModel(
      id: 62,
      quoteText: "Any fool can write code that a computer can understand. Good programmers write code that humans can understand.",
      authorName: "Martin Fowler",
      category: "Programming",
    ),
    const QuoteModel(
      id: 63,
      quoteText: "Make it work, make it right, make it fast.",
      authorName: "Kent Beck",
      category: "Programming",
    ),
    const QuoteModel(
      id: 64,
      quoteText: "First, solve the problem. Then, write the code.",
      authorName: "John Johnson",
      category: "Programming",
    ),
    const QuoteModel(
      id: 65,
      quoteText: "Code is like humor. When you have to explain it, it’s bad.",
      authorName: "Cory House",
      category: "Programming",
    ),
    const QuoteModel(
      id: 66,
      quoteText: "Measuring programming progress by lines of code is like measuring aircraft building progress by weight.",
      authorName: "Bill Gates",
      category: "Programming",
    ),
    const QuoteModel(
      id: 67,
      quoteText: "The best error message is the one that never shows up.",
      authorName: "Thomas Fuchs",
      category: "Programming",
    ),
    const QuoteModel(
      id: 68,
      quoteText: "Computers are good at following instructions, but not at reading your mind.",
      authorName: "Donald Knuth",
      category: "Programming",
    ),
    const QuoteModel(
      id: 69,
      quoteText: "Software is a gas; it expands to fill its container.",
      authorName: "Nathan Myhrvold",
      category: "Programming",
    ),
    const QuoteModel(
      id: 70,
      quoteText: "The best code is no code at all.",
      authorName: "Jeff Atwood",
      category: "Programming",
    ),
    const QuoteModel(
      id: 71,
      quoteText: "Talk is cheap. Show me the code.",
      authorName: "Linus Torvalds",
      category: "Programming",
    ),
    const QuoteModel(
      id: 72,
      quoteText: "Programs must be written for people to read, and only incidentally for machines to execute.",
      authorName: "Harold Abelson",
      category: "Programming",
    ),
    const QuoteModel(
      id: 73,
      quoteText: "Simplicity is the soul of efficiency.",
      authorName: "Austin Freeman",
      category: "Programming",
    ),
    const QuoteModel(
      id: 74,
      quoteText: "Before software can be reusable it first has to be usable.",
      authorName: "Ralph Johnson",
      category: "Programming",
    ),

    // --- Funny (12 Quotes) ---
    const QuoteModel(
      id: 75,
      quoteText: "I can resist everything except temptation.",
      authorName: "Oscar Wilde",
      category: "Funny",
    ),
    const QuoteModel(
      id: 76,
      quoteText: "Whenever you find yourself on the side of the majority, it is time to pause and reflect.",
      authorName: "Mark Twain",
      category: "Funny",
    ),
    const QuoteModel(
      id: 77,
      quoteText: "If you want to tell people the truth, make them laugh, otherwise they'll kill you.",
      authorName: "Oscar Wilde",
      category: "Funny",
    ),
    const QuoteModel(
      id: 78,
      quoteText: "A day without sunshine is like, you know, night.",
      authorName: "Steve Martin",
      category: "Funny",
    ),
    const QuoteModel(
      id: 79,
      quoteText: "I am so clever that sometimes I don't understand a single word of what I am saying.",
      authorName: "Oscar Wilde",
      category: "Funny",
    ),
    const QuoteModel(
      id: 80,
      quoteText: "The safe way to double your money is to fold it over once and put it in your pocket.",
      authorName: "Will Rogers",
      category: "Funny",
    ),
    const QuoteModel(
      id: 81,
      quoteText: "I refuse to join any club that would have me as a member.",
      authorName: "Groucho Marx",
      category: "Funny",
    ),
    const QuoteModel(
      id: 82,
      quoteText: "A bank is a place that will lend you money if you can prove that you don't need it.",
      authorName: "Bob Hope",
      category: "Funny",
    ),
    const QuoteModel(
      id: 83,
      quoteText: "All you need in this life is ignorance and confidence, and then success is sure.",
      authorName: "Mark Twain",
      category: "Funny",
    ),
    const QuoteModel(
      id: 84,
      quoteText: "I always wanted to be somebody, but now I realize I should have been more specific.",
      authorName: "Lily Tomlin",
      category: "Funny",
    ),
    const QuoteModel(
      id: 85,
      quoteText: "Behind every great man is a woman rolling her eyes.",
      authorName: "Jim Carrey",
      category: "Funny",
    ),
    const QuoteModel(
      id: 86,
      quoteText: "Age is something that doesn't matter, unless you are a cheese.",
      authorName: "Luis Buñuel",
      category: "Funny",
    ),

    // --- Wisdom (16 Quotes) ---
    const QuoteModel(
      id: 87,
      quoteText: "The only true wisdom is in knowing you know nothing.",
      authorName: "Socrates",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 88,
      quoteText: "Knowing yourself is the beginning of all wisdom.",
      authorName: "Aristotle",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 90,
      quoteText: "Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself.",
      authorName: "Rumi",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 91,
      quoteText: "The journey of a thousand miles begins with one step.",
      authorName: "Lao Tzu",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 92,
      quoteText: "Out of clutter, find simplicity.",
      authorName: "Albert Einstein",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 93,
      quoteText: "The only thing that is constant is change.",
      authorName: "Heraclitus",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 94,
      quoteText: "Silence is a source of great strength.",
      authorName: "Lao Tzu",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 95,
      quoteText: "He who knows, does not speak. He who speaks, does not know.",
      authorName: "Lao Tzu",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 96,
      quoteText: "It is the mark of an educated mind to be able to entertain a thought without accepting it.",
      authorName: "Aristotle",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 97,
      quoteText: "Be kind, for everyone you meet is fighting a harder battle.",
      authorName: "Plato",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 98,
      quoteText: "An unexamined life is not worth living.",
      authorName: "Socrates",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 99,
      quoteText: "The wound is the place where the Light enters you.",
      authorName: "Rumi",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 100,
      quoteText: "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
      authorName: "Aristotle",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 101,
      quoteText: "Do not seek to follow in the footsteps of the wise. Seek what they sought.",
      authorName: "Matsuo Basho",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 102,
      quoteText: "The simple things are also the most extraordinary things, and only the wise can see them.",
      authorName: "Paulo Coelho",
      category: "Wisdom",
    ),
    const QuoteModel(
      id: 103,
      quoteText: "Wisdom begins in wonder.",
      authorName: "Socrates",
      category: "Wisdom",
    ),
  ];

  /// Get the list of all available quotes.
  static List<QuoteModel> getAllQuotes() {
    return List.unmodifiable(_quotes);
  }

  /// Get the list of quotes belonging to a specific category (case-insensitive).
  /// If the category is 'All', returns all quotes.
  static List<QuoteModel> getByCategory(String category) {
    if (category.toLowerCase() == 'all') {
      return getAllQuotes();
    }
    return _quotes
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Search for quotes by matching query string against quote text, author name,
  /// and category (case-insensitive).
  static List<QuoteModel> search(String query) {
    if (query.trim().isEmpty) {
      return getAllQuotes();
    }
    final lowercaseQuery = query.toLowerCase();
    return _quotes.where((q) {
      return q.quoteText.toLowerCase().contains(lowercaseQuery) ||
          q.authorName.toLowerCase().contains(lowercaseQuery) ||
          q.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
