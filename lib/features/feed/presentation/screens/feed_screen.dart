import 'package:flutter/material.dart';

import '../../data/mock_feed_items.dart';
import '../video/feed_video_controller.dart';
import '../widgets/feed_page.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    required this.topOverlayHeight,
    required this.bottomNavigationHeight,
    required this.isActive,
    this.feedVideoControllerFactory,
    super.key,
  });

  final double topOverlayHeight;
  final double bottomNavigationHeight;
  final bool isActive;
  final FeedVideoControllerFactory? feedVideoControllerFactory;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mockFeedItems.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return FeedPage(
          key: ValueKey(mockFeedItems[index].videoUrl),
          item: mockFeedItems[index],
          topOverlayHeight: widget.topOverlayHeight,
          bottomNavigationHeight: widget.bottomNavigationHeight,
          isActive: widget.isActive && _currentPage == index,
          feedVideoControllerFactory: widget.feedVideoControllerFactory,
        );
      },
    );
  }
}
