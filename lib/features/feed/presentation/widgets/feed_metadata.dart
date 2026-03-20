import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';

class FeedMetadata extends StatelessWidget {
  const FeedMetadata({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.originalTrackLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              child: Text(
                '@${item.authorUsername}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: -0.9,
                ),
              ),
            ),
            if (item.authorIsVerified) ...[
              const SizedBox(width: 6),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFF209CFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          item.caption,
          style: const TextStyle(
            color: Color(0xE6FFFFFF),
            fontSize: 13,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.footnote,
          style: const TextStyle(
            color: Color(0xDEFFFFFF),
            fontSize: 12,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
