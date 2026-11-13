import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/setstate/cart_page_setstate.dart';

void main() {
  testWidgets('Adds keyboard twice and applies SAVE10', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SetStateCartPage(),
      ),
    );

    // Add Keyboard twice.
    await tester.tap(find.text('Keyboard · 49'));
    await tester.pump();

    await tester.tap(find.text('Keyboard · 49'));
    await tester.pump();

    // Enter coupon.
    await tester.enterText(
      find.byType(TextField),
      'SAVE10',
    );

    // Apply coupon.
    await tester.tap(find.text('Apply'));
    await tester.pump();

    // Check calculated total.
    expect(find.text('88.20'), findsOneWidget);
  });
}
