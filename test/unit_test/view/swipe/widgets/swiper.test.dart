import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/swipe/widgets/swiper.dart';

void main() {
  testWidgets('Swipper Tests', (tester) async {
    await tester.pumpWidget(Material(
      child: MaterialApp(
        home: SizedBox(width: 100, height: 100, child: Swiper()),
      ),
    ));

    expect(find.byType(CardSwiper), findsOneWidget);
  });
}
