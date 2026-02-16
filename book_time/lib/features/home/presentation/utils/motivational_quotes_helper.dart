/// Литературные цитаты от великих писателей и мыслителей о книгах и чтении
class MotivationalQuotesHelper {
  MotivationalQuotesHelper._();

  static const List<Map<String, String>> quotes = [
    {
      'text': 'A reader lives a thousand lives before he dies. The man who never reads lives only one.',
      'author': 'George R.R. Martin',
    },
    {
      'text': 'Books are a uniquely portable magic.',
      'author': 'Stephen King',
    },
    {
      'text': 'There is no friend as loyal as a book.',
      'author': 'Ernest Hemingway',
    },
    {
      'text': 'A room without books is like a body without a soul.',
      'author': 'Marcus Tullius Cicero',
    },
    {
      'text': 'The more that you read, the more things you will know.',
      'author': 'Dr. Seuss',
    },
    {
      'text': 'Reading is to the mind what exercise is to the body.',
      'author': 'Joseph Addison',
    },
    {
      'text': 'Books are the mirrors of the soul.',
      'author': 'Virginia Woolf',
    },
    {
      'text': 'Once you learn to read, you will be forever free.',
      'author': 'Frederick Douglass',
    },
    {
      'text': 'Reading gives us someplace to go when we have to stay where we are.',
      'author': 'Mason Cooley',
    },
    {
      'text': 'A book is a dream that you hold in your hand.',
      'author': 'Neil Gaiman',
    },
    {
      'text': 'Today a reader, tomorrow a leader.',
      'author': 'Margaret Fuller',
    },
    {
      'text': 'Reading is an exercise in empathy.',
      'author': 'Malorie Blackman',
    },
    {
      'text': 'Books are the treasured wealth of the world.',
      'author': 'Henry David Thoreau',
    },
    {
      'text': 'One must always be careful of books and what is inside them.',
      'author': 'Cassandra Clare',
    },
    {
      'text': 'Sleep is good, books are better.',
      'author': 'George R.R. Martin',
    },
    {
      'text': 'We read to know we are not alone.',
      'author': 'C.S. Lewis',
    },
    {
      'text': 'Books are the plane, and the train, and the road.',
      'author': 'Anna Quindlen',
    },
    {
      'text': 'I have always imagined that Paradise will be a kind of library.',
      'author': 'Jorge Luis Borges',
    },
  ];

  /// Получить случайную цитату (только текст)
  static String getRandomQuote() {
    final quoteIndex = DateTime.now().millisecond % quotes.length;
    return quotes[quoteIndex]['text']!;
  }

  /// Получить случайную цитату с автором
  static Map<String, String> getRandomQuoteWithAuthor() {
    final quoteIndex = DateTime.now().millisecond % quotes.length;
    return quotes[quoteIndex];
  }

  /// Получить цитату дня (одна цитата на весь день)
  static Map<String, String> getDailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final quoteIndex = dayOfYear % quotes.length;
    return quotes[quoteIndex];
  }
}
