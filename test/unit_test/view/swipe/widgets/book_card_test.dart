import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/swipe/widgets/book_card.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

void main() {
  const color = Colors.black;
  const text = "test";
  group('BookCard tests', () {
    testWidgets('BookCard Widget tests', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Material(child: BookCard(color: color, text: text))));

      expect(find.byType(InfoCard), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
    test('BookCard elements', () {
      const bookCard = BookCard(color: color, text: text);
      expect(bookCard.color, color);
      expect(bookCard.text, text);
    });
  });
}
