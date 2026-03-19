import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';

class FeedMusicDisc extends StatelessWidget {
  const FeedMusicDisc({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF4E4E4E), Color(0xFF101010)],
        ),
        border: Border.all(color: const Color(0x1FFFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x52000000),
            blurRadius: 18,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Center(
        child: ClipOval(
          child: SizedBox(
            width: 28,
            height: 28,
            child: Image.network(
              item.trackCoverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        item.glowColor.withValues(alpha: 0.75),
                        const Color(0xFF101010),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0x22000000),
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xAA000000),
                        blurRadius: 14,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
