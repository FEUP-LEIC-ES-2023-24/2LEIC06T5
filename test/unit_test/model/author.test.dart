import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pagepal/model/author.dart';
import 'package:pagepal/model/book.dart';

import 'author.test.mocks.dart';

@GenerateNiceMocks([MockSpec<Book>()])
void main() {
  group('Author tests', () {
    test('Create an author object', () {
      final newAuthor = Author(name: 'Rubem Neto', books: List.empty());
      expect(newAuthor.name, 'Rubem Neto');
      expect(newAuthor.books, List.empty());
    });
    test('Create author with list of books', () {
      final book = MockBook();
      when(book.genres).thenReturn(['Horror']);
      when(book.title).thenReturn('Dune 27');
      when(book.isbn).thenReturn('123');
      when(book.lang).thenReturn('Portuguese');
      when(book.pubYear).thenReturn(2);

      final author = Author(name: 'Rubem Neto', books: [book]);

      expect(author.name, 'Rubem Neto');
      expect(author.books[0].isbn, '123');
      expect(author.books[0].lang, 'Portuguese');
      expect(author.books[0].pubYear, 2);
    });
  });
}
