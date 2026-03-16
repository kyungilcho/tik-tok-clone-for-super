import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tik_tok_clone_for_super/app.dart';

void main() {
  testWidgets('renders vertical feed scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('For You'), findsWidgets);
    expect(find.text('Faith Valverde. #UCL'), findsOneWidget);
  });
}
