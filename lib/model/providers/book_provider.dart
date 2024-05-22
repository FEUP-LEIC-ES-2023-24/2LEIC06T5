import 'package:flutter/material.dart';
import 'package:pagepal/model/book.dart';

class BooksProvider extends ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => _books;

  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  void setBooks(List<Book> books) {
    _books
      ..clear()
      ..addAll(books);
    notifyListeners();
  }

  void removeBook(Book book) {
    _books.remove(book);
  }
}
