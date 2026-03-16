import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({
    required this.item,
    required this.topOverlayHeight,
    required this.bottomNavigationHeight,
    super.key,
  });

  final FeedItem item;
  final double topOverlayHeight;
  final double bottomNavigationHeight;

  static const _pageBackground = Color(0xFF070707);
  static const _likeColor = Color(0xFFFF2D55);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _pageBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _SceneBackground(item: item),
          const _TopFade(),
          const _BottomFade(),
          if (item.showLikeToast)
            Positioned(
              top: topOverlayHeight + 12,
              left: 14,
              child: const _LikeToast(),
            ),
          if (item.showBuffering)
            const Center(
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0x66FFFFFF),
                ),
              ),
            ),
          if (item.showDoubleTapLike) const Center(child: _BurstHeart()),
          Positioned(
            right: 12,
            bottom: bottomNavigationHeight + 52,
            child: _ActionRail(item: item),
          ),
          Positioned(
            left: 14,
            right: 92,
            bottom: bottomNavigationHeight + 26,
            child: _FeedMetadata(item: item),
          ),
        ],
      ),
    );
  }
}

class _SceneBackground extends StatelessWidget {
  const _SceneBackground({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: item.sceneColors,
            ),
          ),
        ),
        Positioned(
          top: 96,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: Container(
                width: 184,
                height: 184,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [item.glowColor, Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.2),
          child: IgnorePointer(
            child: SizedBox(
              width: 220,
              height: 520,
              child: Stack(
                alignment: Alignment.topCenter,
                children: const [_FigureShadow(), _FigureBody(), _FigureHead()],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FigureShadow extends StatelessWidget {
  const _FigureShadow();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      child: Container(
        width: 212,
        height: 160,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x59000000),
              blurRadius: 44,
              spreadRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class _FigureBody extends StatelessWidget {
  const _FigureBody();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 66,
      child: Container(
        width: 194,
        height: 420,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(120),
            topRight: Radius.circular(120),
            bottomLeft: Radius.circular(38),
            bottomRight: Radius.circular(38),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF2F2F2),
              Color(0xFFD7D7D7),
              Color(0xFFBCBCBC),
              Color(0xFF171717),
              Color(0xFF0F0F0F),
            ],
            stops: [0, 0.4, 0.62, 0.621, 1],
          ),
        ),
      ),
    );
  }
}

class _FigureHead extends StatelessWidget {
  const _FigureHead();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 140,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 8,
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF232425), Color(0xFF111112)],
                  stops: [0.32, 1],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFD6B6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopFade extends StatelessWidget {
  const _TopFade();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: SizedBox(
          height: 176,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x61000000), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomFade extends StatelessWidget {
  const _BottomFade();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: SizedBox(
          height: 280,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB8000000)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LikeToast extends StatelessWidget {
  const _LikeToast();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x2EFF2D55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x47FF2D55)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Color(0xFFFFD8E2), size: 14),
          SizedBox(width: 8),
          Text(
            'Liked on double tap',
            style: TextStyle(
              color: Color(0xFFFFD8E2),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BurstHeart extends StatelessWidget {
  const _BurstHeart();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color(0x55FF2D55), blurRadius: 26, spreadRadius: 2),
        ],
      ),
      child: const Icon(Icons.favorite, size: 112, color: Color(0xFFFF4B73)),
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _AvatarAction(),
          const SizedBox(height: 12),
          _ActionButton(
            icon: Icons.favorite,
            count: item.likeCount,
            color: item.isLiked ? FeedPage._likeColor : Colors.white,
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: CupertinoIcons.chat_bubble_fill,
            count: item.commentCount,
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: Icons.bookmark,
            count: item.bookmarkCount,
            color: Colors.white,
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: CupertinoIcons.arrowshape_turn_up_right_fill,
            count: item.shareCount,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const _MusicDisc(),
        ],
      ),
    );
  }
}

class _AvatarAction extends StatelessWidget {
  const _AvatarAction();

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
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFD3AF),
                  Color(0xFF8A5C47),
                  Color(0xFF090909),
                ],
                stops: [0.22, 0.55, 1],
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
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final String count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: Color(0xF0FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MusicDisc extends StatelessWidget {
  const _MusicDisc();

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
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x22000000), width: 3),
          ),
        ),
      ),
    );
  }
}

class _FeedMetadata extends StatelessWidget {
  const _FeedMetadata({required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.musicLabel,
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
                item.title,
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
