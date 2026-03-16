import 'package:flutter/material.dart';

import '../../data/mock_feed_items.dart';
import '../widgets/feed_page.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    required this.topOverlayHeight,
    required this.bottomNavigationHeight,
    super.key,
  });

  final double topOverlayHeight;
  final double bottomNavigationHeight;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mockFeedItems.length,
      itemBuilder: (context, index) {
        return FeedPage(
          item: mockFeedItems[index],
          topOverlayHeight: topOverlayHeight,
          bottomNavigationHeight: bottomNavigationHeight,
        );
      },
    );
  }
}
