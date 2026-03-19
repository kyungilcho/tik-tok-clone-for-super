import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/feed_item.dart';
import '../domain/repositories/feed_repository.dart';
import 'feed_providers.dart';
import 'feed_state.dart';

class FeedNotifier extends Notifier<FeedState> {
  static const _loadMoreThreshold = 2;

  FeedRepository get _repository => ref.read(feedRepositoryProvider);

  @override
  FeedState build() {
    final initialState = FeedState(
      items: const [],
      currentIndex: 0,
      isInitialLoading: true,
      isLoadingMore: false,
      hasNextPage: false,
      nextPage: 1,
    );

    unawaited(_loadInitialItems());

    return initialState;
  }

  void updateCurrentIndex(int index) {
    if (state.items.isEmpty || index == state.currentIndex) {
      return;
    }

    state = state.copyWith(currentIndex: index);
    unawaited(loadMoreIfNeeded());
  }

  Future<void> loadMoreIfNeeded() async {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    final remainingItems = state.items.length - state.currentIndex - 1;
    if (remainingItems >= _loadMoreThreshold) {
      return;
    }

    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final nextItems = await _repository.fetchMoreFeedItems(
        page: state.nextPage,
      );

      if (nextItems.isEmpty) {
        state = state.copyWith(
          isLoadingMore: false,
          hasNextPage: false,
          errorMessage: null,
        );
        return;
      }

      state = state.copyWith(
        items: [...state.items, ...nextItems],
        isLoadingMore: false,
        nextPage: state.nextPage + 1,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> _loadInitialItems() async {
    try {
      final items = await _repository.getInitialFeedItems();
      state = state.copyWith(
        items: items,
        isInitialLoading: false,
        hasNextPage: items.isNotEmpty,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        hasNextPage: false,
        errorMessage: error.toString(),
      );
    }
  }

  void toggleLike(String itemId) {
    state = state.copyWith(items: _toggleLikeInItems(state.items, itemId));
  }

  void like(String itemId) {
    FeedItem? item;
    for (final feedItem in state.items) {
      if (feedItem.id == itemId) {
        item = feedItem;
        break;
      }
    }

    if (item == null || item.isLiked) {
      return;
    }

    state = state.copyWith(items: _toggleLikeInItems(state.items, itemId));
  }

  void toggleBookmark(String itemId) {
    state = state.copyWith(items: _toggleBookmarkInItems(state.items, itemId));
  }

  List<FeedItem> _toggleLikeInItems(List<FeedItem> items, String itemId) {
    return items.map((item) {
      if (item.id != itemId) {
        return item;
      }

      final nextLiked = !item.isLiked;
      final likeDelta = nextLiked ? 1 : -1;

      return item.copyWith(
        isLiked: nextLiked,
        likeCount: item.likeCount + likeDelta,
      );
    }).toList();
  }

  List<FeedItem> _toggleBookmarkInItems(List<FeedItem> items, String itemId) {
    return items.map((item) {
      if (item.id != itemId) {
        return item;
      }

      final nextBookmarked = !item.isBookmarked;
      final bookmarkDelta = nextBookmarked ? 1 : -1;

      return item.copyWith(
        isBookmarked: nextBookmarked,
        bookmarkCount: item.bookmarkCount + bookmarkDelta,
      );
    }).toList();
  }
}
