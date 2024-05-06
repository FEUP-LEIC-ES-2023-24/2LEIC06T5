import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/shop/shop.dart';

void main() {
  testWidgets('ShopPageView Widget Test', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: ShopPageView(),
    ));
    expect(find.text('SHOP PAGE'), findsOneWidget);
  });
}
