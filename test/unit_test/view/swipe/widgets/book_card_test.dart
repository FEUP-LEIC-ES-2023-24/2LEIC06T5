import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pagepal/model/book.dart';

import 'package:pagepal/view/swipe/widgets/book_card.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

void main() {
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
      title: 'Dune');
  group('BookCard tests', () {
    testWidgets('BookCard Widget tests', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Material(
              child: BookCard(
        book: book,
      ))));

      expect(find.byType(InfoCard), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
    test('BookCard elements', () {
      expect(book.mainAuthor, 'me');
      expect(book.isbn, '123');
    });
  });
}
