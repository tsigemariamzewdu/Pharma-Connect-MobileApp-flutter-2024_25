import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/main.dart' as app;

void main() {
  group('Login Flow Integration Test', () {
    testWidgets('Login form appears and can be filled',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Check for email and password fields
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);

      // Enter email and password
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'password123');

      // Tap the login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // You can add more expectations here, e.g., loading indicator or navigation
    });
  });
}
