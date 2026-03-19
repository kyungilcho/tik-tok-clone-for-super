import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';
import 'feed_page_tokens.dart';

class FeedActionRail extends StatelessWidget {
  const FeedActionRail({
    required this.item,
    required this.onLikeTap,
    super.key,
  });

  final FeedItem item;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FeedAvatarAction(item: item),
          const SizedBox(height: 12),
          FeedActionButton(
            icon: Icons.favorite,
            count: item.likeCount,
            color: item.isLiked ? FeedPageTokens.likeColor : Colors.white,
            onTap: onLikeTap,
          ),
          const SizedBox(height: 14),
          FeedActionButton(
            icon: CupertinoIcons.chat_bubble_fill,
            count: item.commentCount,
            color: Colors.white,
            onTap: _noop,
          ),
          const SizedBox(height: 14),
          FeedActionButton(
            icon: Icons.bookmark,
            count: item.bookmarkCount,
            color: Colors.white,
            onTap: _noop,
          ),
          const SizedBox(height: 14),
          FeedActionButton(
            icon: CupertinoIcons.arrowshape_turn_up_right_fill,
            count: item.shareCount,
            color: Colors.white,
            onTap: _noop,
          ),
          const SizedBox(height: 16),
          FeedMusicDisc(item: item),
        ],
      ),
    );
  }
}

void _noop() {}

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

class FeedActionButton extends StatefulWidget {
  const FeedActionButton({
    required this.icon,
    required this.count,
    required this.color,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  State<FeedActionButton> createState() => _FeedActionButtonState();
}

class _FeedActionButtonState extends State<FeedActionButton> {
  Offset? _downPosition;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (e) => _downPosition = e.localPosition,
      onPointerUp: (e) {
        if (_downPosition != null &&
            (e.localPosition - _downPosition!).distance < 20) {
          widget.onTap();
        }
        _downPosition = null;
      },
      onPointerCancel: (_) => _downPosition = null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            color: widget.color,
            size: 32,
            shadows: FeedPageTokens.overlayIconShadows,
          ),
          const SizedBox(height: 4),
          Text(
            formatSocialCount(widget.count),
            style: const TextStyle(
              color: Color(0xF0FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: FeedPageTokens.overlayIconShadows,
            ),
          ),
        ],
      ),
    );
  }
}

String formatSocialCount(int count) {
  if (count >= 1000000) {
    final value = count / 1000000;
    return '${_trimCompactDecimals(value)}M';
  }

  if (count >= 1000) {
    final value = count / 1000;
    return '${_trimCompactDecimals(value)}K';
  }

  return '$count';
}

String _trimCompactDecimals(double value) {
  final decimals = value >= 100 ? 0 : 1;
  final formatted = value.toStringAsFixed(decimals);
  return formatted.endsWith('.0')
      ? formatted.substring(0, formatted.length - 2)
      : formatted;
}

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
