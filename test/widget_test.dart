import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tik_tok_clone_for_super/app.dart';

void main() {
  testWidgets('renders app shell with home feed by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('For You'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Faith Valverde. #UCL'), findsOneWidget);
  });

  testWidgets('switches to placeholder branch from app shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    await tester.tap(find.text('Friends'));
    await tester.pumpAndSettle();

    expect(find.text('Friends'), findsWidgets);
    expect(
      find.text(
        'Friends branch placeholder. Social graph surfaces can be mounted here later.',
      ),
      findsOneWidget,
    );
  });
}
