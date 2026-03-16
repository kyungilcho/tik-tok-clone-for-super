import 'package:flutter/material.dart';

import '../domain/feed_item.dart';

const mockFeedItems = <FeedItem>[
  FeedItem(
    videoUrl:
        'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    musicLabel: 'UEFA Champions League',
    title: 'Champions League',
    caption: 'Faith Valverde. #UCL',
    footnote: '#RealMadridvsManchesterCity  See original',
    likeCount: '626.6K',
    commentCount: '3,152',
    bookmarkCount: '22.8K',
    shareCount: '13.4K',
    sceneColors: [
      Color(0xFF4B6942),
      Color(0xFF304831),
      Color(0xFF223220),
      Color(0xFF131313),
    ],
    glowColor: Color(0x44FFFFFF),
  ),
  FeedItem(
    videoUrl:
        'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    musicLabel: 'UEFA Champions League',
    title: 'Champions League',
    caption:
        'Overlay stays mounted while the scene dims and the loader appears in the center.',
    footnote: 'Layout holds on top during buffering',
    likeCount: '626.6K',
    commentCount: '3,152',
    bookmarkCount: '22.8K',
    shareCount: '13.4K',
    sceneColors: [
      Color(0xFF36582B),
      Color(0xFF17301A),
      Color(0xFF0C1711),
      Color(0xFF070707),
    ],
    glowColor: Color(0x33E8F5E9),
  ),
  FeedItem(
    videoUrl:
        'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    musicLabel: 'Motion test',
    title: 'Like feedback state',
    caption:
        'Filled heart icon stays pink and the larger central heart scales in during the double tap animation.',
    footnote: 'Single layout, different interaction state',
    likeCount: '629.1K',
    commentCount: '3,208',
    bookmarkCount: '23.1K',
    shareCount: '13.7K',
    sceneColors: [
      Color(0xFF4A6B55),
      Color(0xFF314735),
      Color(0xFF202E23),
      Color(0xFF111111),
    ],
    glowColor: Color(0x40FFC6D8),
    isLiked: true,
    showDoubleTapLike: true,
    showLikeToast: true,
  ),
];
