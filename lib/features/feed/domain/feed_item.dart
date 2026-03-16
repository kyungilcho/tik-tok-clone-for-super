import 'package:flutter/material.dart';

@immutable
class FeedItem {
  const FeedItem({
    required this.musicLabel,
    required this.title,
    required this.caption,
    required this.footnote,
    required this.likeCount,
    required this.commentCount,
    required this.bookmarkCount,
    required this.shareCount,
    required this.sceneColors,
    required this.glowColor,
    this.isLiked = false,
    this.showBuffering = false,
    this.showDoubleTapLike = false,
    this.showLikeToast = false,
  });

  final String musicLabel;
  final String title;
  final String caption;
  final String footnote;
  final String likeCount;
  final String commentCount;
  final String bookmarkCount;
  final String shareCount;
  final List<Color> sceneColors;
  final Color glowColor;
  final bool isLiked;
  final bool showBuffering;
  final bool showDoubleTapLike;
  final bool showLikeToast;
}
