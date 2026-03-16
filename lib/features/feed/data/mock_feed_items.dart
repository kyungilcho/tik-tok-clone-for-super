import 'package:flutter/material.dart';

import '../domain/feed_item.dart';

const mockFeedPages = <List<FeedItem>>[
  [
    FeedItem(
      id: 'ucl-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      musicLabel: 'UEFA Champions League',
      title: 'Champions League',
      caption: 'Faith Valverde. #UCL',
      footnote: '#RealMadridvsManchesterCity  See original',
      likeCount: 626600,
      commentCount: 3152,
      bookmarkCount: 22800,
      shareCount: 13400,
      sceneColors: [
        Color(0xFF4B6942),
        Color(0xFF304831),
        Color(0xFF223220),
        Color(0xFF131313),
      ],
      glowColor: Color(0x44FFFFFF),
    ),
    FeedItem(
      id: 'ucl-02',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      musicLabel: 'UEFA Champions League',
      title: 'Champions League',
      caption:
          'Overlay stays mounted while the scene dims and the loader appears in the center.',
      footnote: 'Layout holds on top during buffering',
      likeCount: 626600,
      commentCount: 3152,
      bookmarkCount: 22800,
      shareCount: 13400,
      sceneColors: [
        Color(0xFF36582B),
        Color(0xFF17301A),
        Color(0xFF0C1711),
        Color(0xFF070707),
      ],
      glowColor: Color(0x33E8F5E9),
    ),
    FeedItem(
      id: 'motion-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      musicLabel: 'Motion test',
      title: 'Like feedback state',
      caption:
          'Filled heart icon stays pink and the larger central heart scales in during the double tap animation.',
      footnote: 'Single layout, different interaction state',
      likeCount: 629100,
      commentCount: 3208,
      bookmarkCount: 23100,
      shareCount: 13700,
      sceneColors: [
        Color(0xFF4A6B55),
        Color(0xFF314735),
        Color(0xFF202E23),
        Color(0xFF111111),
      ],
      glowColor: Color(0x40FFC6D8),
      isLiked: true,
    ),
  ],
  [
    FeedItem(
      id: 'city-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      musicLabel: 'Midnight drive',
      title: 'Neon street run',
      caption:
          'Second page starts only when you reach the end of the first mock set.',
      footnote: 'Mock pagination page 2',
      likeCount: 418500,
      commentCount: 1870,
      bookmarkCount: 12900,
      shareCount: 7600,
      sceneColors: [
        Color(0xFF3D3C73),
        Color(0xFF2A2953),
        Color(0xFF171833),
        Color(0xFF09090D),
      ],
      glowColor: Color(0x4489A8FF),
    ),
    FeedItem(
      id: 'food-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      musicLabel: 'Kitchen test',
      title: 'One-pan dinner',
      caption:
          'Different metadata and counts make the load-more step feel like a real new batch.',
      footnote: 'Fresh set, not a clone of page 1',
      likeCount: 289400,
      commentCount: 942,
      bookmarkCount: 18200,
      shareCount: 5100,
      sceneColors: [
        Color(0xFF7C5036),
        Color(0xFF55351F),
        Color(0xFF25160E),
        Color(0xFF0D0A08),
      ],
      glowColor: Color(0x44FFB36B),
    ),
    FeedItem(
      id: 'travel-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      musicLabel: 'Weekend escape',
      title: 'Road to the ridge',
      caption:
          'This batch uses a different sample video source so the feed does not feel looped.',
      footnote: 'Mock pagination page 2',
      likeCount: 507800,
      commentCount: 2214,
      bookmarkCount: 30400,
      shareCount: 11800,
      sceneColors: [
        Color(0xFF586C67),
        Color(0xFF334440),
        Color(0xFF1B2321),
        Color(0xFF090A0A),
      ],
      glowColor: Color(0x447BE7D5),
    ),
  ],
  [
    FeedItem(
      id: 'sport-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      musicLabel: 'Final wave',
      title: 'Last mock batch',
      caption:
          'Third page proves pagination can continue without repeating the first three cards.',
      footnote: 'Mock pagination page 3',
      likeCount: 712300,
      commentCount: 4012,
      bookmarkCount: 26400,
      shareCount: 16600,
      sceneColors: [
        Color(0xFF605B8C),
        Color(0xFF3A365C),
        Color(0xFF201D32),
        Color(0xFF0D0C16),
      ],
      glowColor: Color(0x44D8C8FF),
    ),
    FeedItem(
      id: 'style-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      musicLabel: 'Studio cut',
      title: 'Fabric motion',
      caption:
          'Counts and copy are unique here so like state is easy to verify on later pages too.',
      footnote: 'Mock pagination page 3',
      likeCount: 193700,
      commentCount: 688,
      bookmarkCount: 9700,
      shareCount: 3900,
      sceneColors: [
        Color(0xFF6D4A4B),
        Color(0xFF482C2D),
        Color(0xFF251516),
        Color(0xFF0C0909),
      ],
      glowColor: Color(0x44FF9FA3),
    ),
    FeedItem(
      id: 'night-01',
      videoUrl:
          'https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      musicLabel: 'After hours',
      title: 'Blue hour',
      caption:
          'After this page the repository returns empty, so the feed naturally stops extending.',
      footnote: 'Mock pagination page 3',
      likeCount: 355900,
      commentCount: 1491,
      bookmarkCount: 14300,
      shareCount: 6800,
      sceneColors: [
        Color(0xFF355574),
        Color(0xFF23384C),
        Color(0xFF13202C),
        Color(0xFF081018),
      ],
      glowColor: Color(0x4484D5FF),
    ),
  ],
];
