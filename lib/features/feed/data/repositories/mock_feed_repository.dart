import '../../domain/feed_item.dart';
import '../../domain/repositories/feed_repository.dart';
import '../mock_feed_items.dart';

class MockFeedRepository implements FeedRepository {
  @override
  List<FeedItem> getInitialFeedItems() {
    return _pageAt(0);
  }

  @override
  Future<List<FeedItem>> fetchMoreFeedItems({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return _pageAt(page);
  }

  List<FeedItem> _pageAt(int page) {
    if (page < 0 || page >= mockFeedPages.length) {
      return const [];
    }

    return mockFeedPages[page]
        .map((item) => item.copyWith(id: item.id, isLiked: item.isLiked))
        .toList();
  }
}
