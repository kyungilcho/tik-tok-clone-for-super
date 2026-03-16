import 'package:flutter_test/flutter_test.dart';
import 'package:tik_tok_clone_for_super/main.dart';

void main() {
  testWidgets('renders assignment scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('TikTok Clone'), findsOneWidget);
  });
}
