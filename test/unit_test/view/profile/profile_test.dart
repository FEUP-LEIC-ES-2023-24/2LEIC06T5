import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pagepal/view/profile/profile.dart';

void main() {
  testWidgets('ProfilePage display a Dialog if add button is clicked',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ProfilePageView(),
    ));
    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
