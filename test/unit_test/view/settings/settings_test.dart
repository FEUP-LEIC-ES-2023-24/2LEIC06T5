import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/settings/settings.dart';

void main() {
  testWidgets('SettingsPageView Widget Test', (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(
      home: SettingsPageView(),
    ));
    expect(find.text('SETTINGS PAGE'), findsOneWidget);
  });
}
