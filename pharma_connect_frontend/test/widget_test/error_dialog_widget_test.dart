import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/presentation/widgets/error_dialog.dart';

void main() {
  testWidgets('ErrorDialog displays error message',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ErrorDialog(message: 'Test error'),
      ),
    ));
    expect(find.text('Test error'), findsOneWidget);
  });
}
