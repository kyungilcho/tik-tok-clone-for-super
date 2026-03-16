import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/mock_feed_repository.dart';
import '../domain/feed_item.dart';
import '../domain/repositories/feed_repository.dart';
import '../presentation/video/feed_video_controller.dart';
import '../presentation/video/video_player_feed_video_controller.dart';
import 'feed_notifier.dart';
import 'feed_state.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  return MockFeedRepository();
});

final feedNotifierProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);

final feedItemsProvider = Provider<List<FeedItem>>((ref) {
  return ref.watch(feedNotifierProvider.select((state) => state.items));
});

final currentFeedIndexProvider = Provider<int>((ref) {
  return ref.watch(feedNotifierProvider.select((state) => state.currentIndex));
});

final isFeedLoadingMoreProvider = Provider<bool>((ref) {
  return ref.watch(feedNotifierProvider.select((state) => state.isLoadingMore));
});

final feedPaginationErrorProvider = Provider<String?>((ref) {
  return ref.watch(feedNotifierProvider.select((state) => state.errorMessage));
});

final feedVideoControllerFactoryProvider = Provider<FeedVideoControllerFactory>(
  (ref) {
    return VideoPlayerFeedVideoController.new;
  },
);
