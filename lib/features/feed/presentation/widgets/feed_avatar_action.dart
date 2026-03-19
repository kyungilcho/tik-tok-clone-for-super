import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';
import 'feed_page_tokens.dart';

class FeedAvatarAction extends StatelessWidget {
  const FeedAvatarAction({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 64,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xEBFFFFFF), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xAA000000),
                  blurRadius: 14,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                item.authorAvatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: item.sceneColors.take(3).toList(),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item.authorDisplayName.isEmpty
                            ? '?'
                            : item.authorDisplayName
                                  .substring(0, 1)
                                  .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFF2D55),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFF070707), width: 2),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 14,
                shadows: FeedPageTokens.overlayIconShadows,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
