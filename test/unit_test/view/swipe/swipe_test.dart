import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/swipe/swipe.dart';
import 'package:pagepal/view/swipe/widgets/swiper.dart';

void main() {
  testWidgets('Swipe Widget Tests', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SwipePageView()));

    expect(find.byType(Swiper), findsOneWidget);
    expect(find.text('Location '), findsOneWidget);
  });
}
