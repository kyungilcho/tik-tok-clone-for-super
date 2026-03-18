import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/feed_item.dart';
import '../../domain/repositories/feed_repository.dart';

class MockFeedRepository implements FeedRepository {
  static const _pageAssetPaths = [
    'assets/fixtures/feed/page_1.json',
    'assets/fixtures/feed/page_2.json',
    'assets/fixtures/feed/page_3.json',
    'assets/fixtures/feed/page_4.json',
    'assets/fixtures/feed/page_5.json',
  ];

  @override
  Future<List<FeedItem>> getInitialFeedItems() {
    return _loadPage(0);
  }

  @override
  Future<List<FeedItem>> fetchMoreFeedItems({required int page}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    return _loadPage(page);
  }

  Future<List<FeedItem>> _loadPage(int page) async {
    if (page < 0 || page >= _pageAssetPaths.length) {
      return const [];
    }

    final jsonString = await rootBundle.loadString(_pageAssetPaths[page]);
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final itemsJson = decoded['items'] as List<dynamic>? ?? const [];

    return itemsJson
        .map((itemJson) => FeedItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
  }
}
