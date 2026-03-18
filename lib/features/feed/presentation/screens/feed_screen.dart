import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/feed_providers.dart';
import '../widgets/feed_page.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({
    required this.topOverlayHeight,
    required this.bottomNavigationHeight,
    required this.isActive,
    super.key,
  });

  final double topOverlayHeight;
  final double bottomNavigationHeight;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(feedItemsProvider);
    final currentPage = ref.watch(currentFeedIndexProvider);
    final isInitialLoading = ref.watch(isFeedInitialLoadingProvider);
    final isLoadingMore = ref.watch(isFeedLoadingMoreProvider);
    final paginationError = ref.watch(feedPaginationErrorProvider);

    if (items.isEmpty && isInitialLoading) {
      return const Center(
        child: SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            paginationError ?? 'Unable to load feed fixtures.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      onPageChanged: (index) {
        ref.read(feedNotifierProvider.notifier).updateCurrentIndex(index);
      },
      itemBuilder: (context, index) {
        final item = items[index];

        return FeedPage(
          key: ValueKey(item.id),
          item: item,
          topOverlayHeight: topOverlayHeight,
          bottomNavigationHeight: bottomNavigationHeight,
          isActive: isActive && currentPage == index,
          isLoadingMore: isLoadingMore && index == items.length - 1,
          paginationError: paginationError,
        );
      },
    );
  }
}
