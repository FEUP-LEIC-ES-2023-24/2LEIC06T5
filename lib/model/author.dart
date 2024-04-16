import 'package:pagepal/model/book.dart';

class Author {
  Author({required this.name, required this.books});
  final String name;
  final List<Book> books;
}
