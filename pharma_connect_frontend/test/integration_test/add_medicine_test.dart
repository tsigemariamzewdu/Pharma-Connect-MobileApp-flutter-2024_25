import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/main.dart' as app;

void main() {
  group('Add Medicine Integration Test', () {
    testWidgets('Fill and submit add medicine form',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to add medicine screen
      // This assumes you can navigate to /medicine/edit for adding
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .pushNamed('/medicine/edit');
      await tester.pumpAndSettle();

      // Fill the form fields
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Medicine Name *'),
          'Test Medicine');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Category *'), 'Test Category');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Description *'),
          'Test Description');
      await tester.enterText(find.widgetWithText(TextFormField, 'Image URL *'),
          'https://example.com/image.png');

      // Tap the save button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pump();

      // You can add more expectations here, e.g., success snackbar
    });
  });
}
