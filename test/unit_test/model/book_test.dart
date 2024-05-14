import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/model/book.dart';

void main() {
  group('Book object tests', () {
    test('Create a book object', () {
      final book = Book(
          mainAuthor: 'me',
          authors: ['Rubem', 'Goiana', 'Marta', 'Alex', 'Rachel'],
          genres: ['Horror'],
          isbn: "123",
          lang: "Portuguese",
          pubYear: '2',
          image: const Image(
            image: AssetImage('assets/dune.jpg'),
          ),
          title: "Dune 27");
      expect(book.authors, ['Rubem', 'Goiana', 'Marta', 'Alex', 'Rachel']);
      expect(book.genres, ['Horror']);
      expect(book.isbn, '123');
      expect(book.pubYear, '2');
      expect(book.title, 'Dune 27');
    });
  });
}
