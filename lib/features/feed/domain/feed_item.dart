import 'package:flutter/material.dart';

@immutable
class FeedItem {
  const FeedItem({
    required this.id,
    required this.videoUrl,
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
  });

  final String id;
  final String videoUrl;
  final String musicLabel;
  final String title;
  final String caption;
  final String footnote;
  final int likeCount;
  final int commentCount;
  final int bookmarkCount;
  final int shareCount;
  final List<Color> sceneColors;
  final Color glowColor;
  final bool isLiked;

  FeedItem copyWith({
    String? id,
    String? videoUrl,
    String? musicLabel,
    String? title,
    String? caption,
    String? footnote,
    int? likeCount,
    int? commentCount,
    int? bookmarkCount,
    int? shareCount,
    List<Color>? sceneColors,
    Color? glowColor,
    bool? isLiked,
  }) {
    return FeedItem(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      musicLabel: musicLabel ?? this.musicLabel,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      footnote: footnote ?? this.footnote,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      shareCount: shareCount ?? this.shareCount,
      sceneColors: sceneColors ?? this.sceneColors,
      glowColor: glowColor ?? this.glowColor,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
