import 'package:flutter/material.dart';

class BooksProvider extends ChangeNotifier {
  final List<Image> _books = [];

  List<Image> get books => _books;

  void addBook(Image book) {
    _books.add(book);
    notifyListeners();
  }

  void setBooks(List<Image> books) {
    _books
      ..clear()
      ..addAll(books);
    notifyListeners();
  }
}
