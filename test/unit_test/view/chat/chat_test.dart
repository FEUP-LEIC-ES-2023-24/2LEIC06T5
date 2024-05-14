import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/chat/chat.dart';

void main() {
  testWidgets('ChatPageView Widget Tests', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: ChatPageView(),
    ));
    expect(find.text('CHAT PAGE'), findsOneWidget);
  });
}
