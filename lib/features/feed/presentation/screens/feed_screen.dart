import 'package:flutter/material.dart';

import '../../data/mock_feed_items.dart';
import '../widgets/feed_page.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: mockFeedItems.length,
        itemBuilder: (context, index) {
          return FeedPage(item: mockFeedItems[index]);
        },
      ),
    );
  }
}
