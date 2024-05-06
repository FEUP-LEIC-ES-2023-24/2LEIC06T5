import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/swipe/widgets/little_info_card.dart';

void main() {
  testWidgets('InfoCard Tests', (tester) async {
    await tester.pumpWidget(const Material(
      child: MaterialApp(home: InfoCard()),
    ));

    // TODO: STILL HARDCODED
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Frank Herbert'), findsOneWidget);

    // TODO: Tests for onTap Function
  });
}
