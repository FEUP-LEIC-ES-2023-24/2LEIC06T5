class Book {
  Book(
      {required this.authors,
      required this.genres,
      required this.isbn,
      required this.lang,
      required this.pubYear,
      required this.title});

  final List<String> authors;
  final List<String> genres;
  final String isbn;
  final String lang;
  final int pubYear;
  final String title;
}
