import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/presentation/widgets/loading_indicator.dart';

void main() {
  testWidgets('LoadingIndicator shows CircularProgressIndicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingIndicator()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
