import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/model/user.dart';

import 'author_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Book>()])
void main() {
  group('User class Tests', () {
    final book = MockBook();
    when(book.genres).thenReturn(['Horror']);
    when(book.title).thenReturn('Dune 27');
    when(book.isbn).thenReturn('123');
    when(book.lang).thenReturn('Portuguese');
    when(book.pubYear).thenReturn('2');

    final user = User(
        email: 'rubem@gmail.com',
        username: 'Rubem Neto',
        likedGenres: ['Horror', 'Romance', 'Fantasy'],
        books: [book]);

    final expectedJson = {
      'email': 'rubem@gmail.com',
      'username': 'Rubem Neto',
      'likedGenre': ['Horror', 'Romance', 'Fantasy'],
      'owns': [book],
    };

    test('Create an User Object', () {
      expect(user.username, 'Rubem Neto');
      expect(user.books, [book]);
      expect(user.email, 'rubem@gmail.com');
      expect(user.likedGenres, ['Horror', 'Romance', 'Fantasy']);
    });

    test('Test User To Json', () {
      final json = user.toJson();
      expect(json, expectedJson);
    });

    test('Test User from Json', () {
      final userFromJson = User.fromJson(expectedJson);
      expect(user.username, userFromJson.username);
      expect(user.books, userFromJson.books);
      expect(user.email, userFromJson.email);
      expect(user.likedGenres, userFromJson.likedGenres);
    });
  });
}
