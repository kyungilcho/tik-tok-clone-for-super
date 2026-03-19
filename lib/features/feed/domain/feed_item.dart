import 'package:flutter/material.dart';

@immutable
class FeedItem {
  const FeedItem({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    required this.authorDisplayName,
    required this.authorAvatarUrl,
    required this.authorIsVerified,
    required this.trackId,
    required this.trackTitle,
    required this.trackArtist,
    required this.trackCoverImageUrl,
    required this.videoUrl,
    required this.videoThumbnailUrl,
    required this.videoDurationMs,
    required this.videoAspectRatio,
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
    this.isBookmarked = false,
  });

  final String id;
  final String authorId;
  final String authorUsername;
  final String authorDisplayName;
  final String authorAvatarUrl;
  final bool authorIsVerified;
  final String trackId;
  final String trackTitle;
  final String trackArtist;
  final String trackCoverImageUrl;
  final String videoUrl;
  final String videoThumbnailUrl;
  final int videoDurationMs;
  final double videoAspectRatio;
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
  final bool isBookmarked;

  String get musicLabel =>
      trackArtist.isEmpty ? trackTitle : '$trackTitle · $trackArtist';

  String get originalTrackLabel => trackArtist.isEmpty
      ? 'Original track - $trackTitle'
      : 'Original track - $trackTitle · $trackArtist';

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    final video = json['video'] as Map<String, dynamic>;
    final author = json['author'] as Map<String, dynamic>;
    final track = json['track'] as Map<String, dynamic>;
    final caption = json['caption'] as Map<String, dynamic>;
    final metrics = json['metrics'] as Map<String, dynamic>;
    final interaction = json['interaction'] as Map<String, dynamic>;
    final visual = json['visual'] as Map<String, dynamic>;

    return FeedItem(
      id: json['id'] as String,
      authorId: author['id'] as String,
      authorUsername: author['username'] as String,
      authorDisplayName: author['displayName'] as String,
      authorAvatarUrl: author['avatarUrl'] as String,
      authorIsVerified: author['isVerified'] as bool? ?? false,
      trackId: track['id'] as String,
      trackTitle: track['title'] as String,
      trackArtist: track['artist'] as String,
      trackCoverImageUrl: track['coverImageUrl'] as String,
      videoUrl: video['url'] as String,
      videoThumbnailUrl: video['thumbnailUrl'] as String,
      videoDurationMs: video['durationMs'] as int? ?? 0,
      videoAspectRatio: (video['aspectRatio'] as num?)?.toDouble() ?? 9 / 16,
      title: json['title'] as String? ?? author['displayName'] as String,
      caption: caption['text'] as String,
      footnote: caption['footnote'] as String? ?? '',
      likeCount: metrics['likeCount'] as int? ?? 0,
      commentCount: metrics['commentCount'] as int? ?? 0,
      bookmarkCount: metrics['bookmarkCount'] as int? ?? 0,
      shareCount: metrics['shareCount'] as int? ?? 0,
      sceneColors: (visual['sceneColors'] as List<dynamic>? ?? const [])
          .map((value) => _colorFromHex(value as String))
          .toList(),
      glowColor: _colorFromHex(visual['glowColor'] as String? ?? '#44FFFFFF'),
      isLiked: interaction['isLiked'] as bool? ?? false,
      isBookmarked: interaction['isBookmarked'] as bool? ?? false,
    );
  }

  FeedItem copyWith({
    String? id,
    String? authorId,
    String? authorUsername,
    String? authorDisplayName,
    String? authorAvatarUrl,
    bool? authorIsVerified,
    String? trackId,
    String? trackTitle,
    String? trackArtist,
    String? trackCoverImageUrl,
    String? videoUrl,
    String? videoThumbnailUrl,
    int? videoDurationMs,
    double? videoAspectRatio,
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
    bool? isBookmarked,
  }) {
    return FeedItem(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorUsername: authorUsername ?? this.authorUsername,
      authorDisplayName: authorDisplayName ?? this.authorDisplayName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorIsVerified: authorIsVerified ?? this.authorIsVerified,
      trackId: trackId ?? this.trackId,
      trackTitle: trackTitle ?? this.trackTitle,
      trackArtist: trackArtist ?? this.trackArtist,
      trackCoverImageUrl: trackCoverImageUrl ?? this.trackCoverImageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      videoThumbnailUrl: videoThumbnailUrl ?? this.videoThumbnailUrl,
      videoDurationMs: videoDurationMs ?? this.videoDurationMs,
      videoAspectRatio: videoAspectRatio ?? this.videoAspectRatio,
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
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

Color _colorFromHex(String hex) {
  final normalized = hex.replaceFirst('#', '');
  final value = normalized.length == 6 ? 'FF$normalized' : normalized;
  return Color(int.parse(value, radix: 16));
}
