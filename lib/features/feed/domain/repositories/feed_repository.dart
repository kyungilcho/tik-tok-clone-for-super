import '../feed_item.dart';

abstract class FeedRepository {
  Future<List<FeedItem>> getInitialFeedItems();

  Future<List<FeedItem>> fetchMoreFeedItems({required int page});
}
