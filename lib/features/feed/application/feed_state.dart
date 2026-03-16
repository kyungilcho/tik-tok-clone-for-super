import 'package:flutter/foundation.dart';

import '../domain/feed_item.dart';

@immutable
class FeedState {
  const FeedState({
    required this.items,
    required this.currentIndex,
    required this.isLoadingMore,
    required this.hasNextPage,
    required this.nextPage,
    this.errorMessage,
  });

  final List<FeedItem> items;
  final int currentIndex;
  final bool isLoadingMore;
  final bool hasNextPage;
  final int nextPage;
  final String? errorMessage;

  static const _noErrorUpdate = Object();

  FeedState copyWith({
    List<FeedItem>? items,
    int? currentIndex,
    bool? isLoadingMore,
    bool? hasNextPage,
    int? nextPage,
    Object? errorMessage = _noErrorUpdate,
  }) {
    return FeedState(
      items: items ?? this.items,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      nextPage: nextPage ?? this.nextPage,
      errorMessage: errorMessage == _noErrorUpdate
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
