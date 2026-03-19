import 'package:flutter/material.dart';

import 'feed_page_tokens.dart';
import 'feed_social_count.dart';

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
      onPointerDown: (event) => _downPosition = event.localPosition,
      onPointerUp: (event) {
        if (_downPosition != null &&
            (event.localPosition - _downPosition!).distance < 20) {
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
