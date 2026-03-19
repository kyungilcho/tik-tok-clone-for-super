import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';
import 'feed_action_button.dart';
import 'feed_avatar_action.dart';
import 'feed_bookmark_button.dart';
import 'feed_like_button.dart';
import 'feed_music_disc.dart';

class FeedActionRail extends StatelessWidget {
  const FeedActionRail({
    required this.item,
    required this.onAvatarTap,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onBookmarkTap,
    required this.onShareTap,
    required this.onMusicTap,
    super.key,
  });

  final FeedItem item;
  final VoidCallback onAvatarTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback onShareTap;
  final VoidCallback onMusicTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FeedAvatarAction(item: item, onTap: onAvatarTap),
          const SizedBox(height: 12),
          FeedLikeButton(
            count: item.likeCount,
            isLiked: item.isLiked,
            onTap: onLikeTap,
          ),
          const SizedBox(height: 14),
          FeedActionButton(
            icon: CupertinoIcons.chat_bubble_fill,
            count: item.commentCount,
            color: Colors.white,
            onTap: onCommentTap,
          ),
          const SizedBox(height: 14),
          FeedBookmarkButton(
            count: item.bookmarkCount,
            isBookmarked: item.isBookmarked,
            onTap: onBookmarkTap,
          ),
          const SizedBox(height: 14),
          FeedActionButton(
            icon: CupertinoIcons.arrowshape_turn_up_right_fill,
            count: item.shareCount,
            color: Colors.white,
            onTap: onShareTap,
          ),
          const SizedBox(height: 16),
          FeedMusicDisc(item: item, onTap: onMusicTap),
        ],
      ),
    );
  }
}
