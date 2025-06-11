import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/main.dart' as app;

void main() {
  group('Profile Screen Integration Test', () {
    testWidgets('Profile information and Edit Profile button are visible',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile screen
      // This assumes you are already logged in or can navigate to /profile
      // If login is required, you may need to perform login steps first
      // For now, try to push the route
      tester
          .state<NavigatorState>(find.byType(Navigator))
          .pushNamed('/profile');
      await tester.pumpAndSettle();

      // Check for profile information widgets
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
    });
  });
}
