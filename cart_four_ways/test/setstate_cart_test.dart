
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cart_four_ways/setstate/cart_page_setstate.dart';

void main() {
  testWidgets('Adds keyboard twice and applies SAVE10', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: SetStateCartPage(),
      ),
    );

    // Find the three product Add buttons.
    final addButtons = find.byIcon(Icons.add_shopping_cart);

    // Add Keyboard twice (first product in catalog).
    await tester.tap(addButtons.at(0));
    await tester.pump();

    await tester.tap(addButtons.at(0));
    await tester.pump();

    // Apply SAVE10.
    await tester.enterText(
      find.byType(TextField),
      'SAVE10',
    );

    await tester.tap(find.text('Apply'));
    await tester.pump();

    // Verify cart calculations.
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('\$98.00'), findsOneWidget);
    expect(find.text('\$88.20'), findsOneWidget);
  });
}
