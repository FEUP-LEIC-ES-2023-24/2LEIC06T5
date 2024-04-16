import 'package:flutter/cupertino.dart';

class Book {
  Book(
      {required this.authors,
      required this.genres,
      required this.isbn,
      required this.lang,
      required this.pubYear,
      required this.title,
      this.image = const Image(
        image: AssetImage("assets/dune.jpg"),
      )});

  final List<String> authors;
  final List<String> genres;
  final String isbn;
  final String lang;
  final String pubYear;
  final String title;
  final Image image;
}
