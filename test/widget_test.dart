import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tik_tok_clone_for_super/app.dart';
import 'package:tik_tok_clone_for_super/features/feed/application/feed_providers.dart';
import 'package:tik_tok_clone_for_super/features/feed/domain/feed_item.dart';
import 'package:tik_tok_clone_for_super/features/feed/domain/repositories/feed_repository.dart';
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

class FakeFeedRepository implements FeedRepository {
  const FakeFeedRepository();

  @override
  Future<List<FeedItem>> fetchMoreFeedItems({required int page}) async {
    return const [];
  }

  @override
  Future<List<FeedItem>> getInitialFeedItems() async {
    return const [
      FeedItem(
        id: 'test-video-001',
        authorId: 'author-001',
        authorUsername: 'faith.valverde',
        authorDisplayName: 'Faith Valverde',
        authorAvatarUrl: 'https://example.com/avatar.jpg',
        authorIsVerified: true,
        trackId: 'track-001',
        trackTitle: 'UEFA Champions League',
        trackArtist: 'Official',
        trackCoverImageUrl: 'https://example.com/track.jpg',
        videoUrl: 'https://example.com/video.mp4',
        videoThumbnailUrl: 'https://example.com/thumb.jpg',
        videoDurationMs: 18000,
        videoAspectRatio: 1.7778,
        title: 'Champions League',
        caption: 'Faith Valverde. #UCL',
        footnote: '#RealMadridvsManchesterCity  See original',
        likeCount: 626600,
        commentCount: 3152,
        bookmarkCount: 22800,
        shareCount: 13400,
        sceneColors: [
          Color(0xFF4B6942),
          Color(0xFF304831),
          Color(0xFF223220),
          Color(0xFF131313),
        ],
        glowColor: Color(0x44FFFFFF),
      ),
    ];
  }
}

void main() {
  FeedVideoController fakeFactory(String _) => FakeFeedVideoController();
  const fakeRepository = FakeFeedRepository();

  testWidgets('renders app shell with home feed by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          feedRepositoryProvider.overrideWithValue(fakeRepository),
          feedVideoControllerFactoryProvider.overrideWithValue(fakeFactory),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          feedRepositoryProvider.overrideWithValue(fakeRepository),
          feedVideoControllerFactoryProvider.overrideWithValue(fakeFactory),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Friends'));
    await tester.pumpAndSettle();

    expect(find.text('Friends'), findsWidgets);
    expect(find.byType(PageView), findsNothing);
  });
}
