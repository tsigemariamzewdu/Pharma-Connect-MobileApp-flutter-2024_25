import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/main.dart' as app;

void main() {
  group('Search Medicine Integration Test', () {
    testWidgets('Search bar is present and can enter search query',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to medicine list screen
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/home');
      await tester.pumpAndSettle();
      // If /home is not the medicine list, use the correct route

      // Find the search bar and enter a query
      final searchField = find.byType(TextField).first;
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Test Medicine');
      await tester.pump();

      // You can add more expectations here, e.g., filtered results
    });
  });
}
