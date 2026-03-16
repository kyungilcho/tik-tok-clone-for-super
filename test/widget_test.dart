import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tik_tok_clone_for_super/app.dart';
import 'package:tik_tok_clone_for_super/features/feed/presentation/video/feed_video_controller.dart';

class FakeFeedVideoController implements FeedVideoController {
  FakeFeedVideoController()
    : _state = ValueNotifier(const FeedVideoState(isInitialized: false));

  final ValueNotifier<FeedVideoState> _state;

  @override
  ValueListenable<FeedVideoState> get state => _state;

  @override
  Widget buildView() {
    return const ColoredBox(color: Colors.black);
  }

  @override
  Future<void> dispose() async {
    _state.dispose();
  }

  @override
  Future<void> initialize() async {
    _state.value = const FeedVideoState(
      isInitialized: true,
      isBuffering: false,
      videoSize: Size(1080, 1920),
    );
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> play() async {}
}

void main() {
  FeedVideoController fakeFactory(String _) => FakeFeedVideoController();

  testWidgets('renders app shell with home feed by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(App(feedVideoControllerFactory: fakeFactory));
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
    await tester.pumpWidget(App(feedVideoControllerFactory: fakeFactory));
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
