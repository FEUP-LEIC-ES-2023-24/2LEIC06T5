import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/model/book.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

void main() {
  testWidgets('InfoCard Tests', (tester) async {
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
    await tester.pumpWidget(Material(
      child: MaterialApp(home: InfoCard(book: book)),
    ));

    // TODO: STILL HARDCODED
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('me'), findsOneWidget);

    // TODO: Tests for onTap Function
  });
}
