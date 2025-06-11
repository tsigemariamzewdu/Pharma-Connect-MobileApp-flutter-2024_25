import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/main.dart' as app;

void main() {
  group('Add to Cart Integration Test', () {
    testWidgets('Add to cart button adds item and shows snackbar',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to medicine list screen
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/home');
      await tester.pumpAndSettle();

      // Tap the first medicine card to go to details
      final medicineCard = find.byType(Card).first;
      await tester.tap(medicineCard);
      await tester.pumpAndSettle();

      // Tap the Add to Cart button
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      expect(addToCartButton, findsOneWidget);
      await tester.tap(addToCartButton);
      await tester.pump();

      // Check for snackbar
      expect(find.text('Added to cart'), findsOneWidget);
    });
  });
}
