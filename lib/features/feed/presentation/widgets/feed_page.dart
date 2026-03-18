import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/feed_providers.dart';
import '../../domain/feed_item.dart';
import '../../../shared/presentation/widgets/muted_tiktok_logo.dart';
import '../video/feed_video_controller.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({
    required this.item,
    required this.topOverlayHeight,
    required this.bottomNavigationHeight,
    required this.isActive,
    this.isLoadingMore = false,
    this.paginationError,
    super.key,
  });

  final FeedItem item;
  final double topOverlayHeight;
  final double bottomNavigationHeight;
  final bool isActive;
  final bool isLoadingMore;
  final String? paginationError;

  static const pageBackground = Color(0xFF070707);
  static const likeColor = Color(0xFFFF2D55);
  static const overlayIconShadows = [
    Shadow(color: Color(0xCC000000), blurRadius: 14, offset: Offset.zero),
  ];

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late final FeedVideoController _videoController;
  bool _isManuallyPaused = false;
  bool _showDebugBuffering = false;
  bool _showBurstHeart = false;
  Offset? _doubleTapPosition;
  Timer? _likeOverlayTimer;
  Timer? _debugBufferingTimer;

  @override
  void initState() {
    super.initState();
    final controllerFactory = ref.read(feedVideoControllerFactoryProvider);
    _videoController = controllerFactory(widget.item.videoUrl);
    unawaited(_initializeAndSync());
  }

  @override
  void didUpdateWidget(covariant FeedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (!widget.isActive) {
        _isManuallyPaused = false;
        _showDebugBuffering = false;
        _debugBufferingTimer?.cancel();
      }
      unawaited(_syncPlayback());
    }
  }

  @override
  void dispose() {
    _likeOverlayTimer?.cancel();
    _debugBufferingTimer?.cancel();
    unawaited(_videoController.dispose());
    super.dispose();
  }

  Future<void> _initializeAndSync() async {
    try {
      await _videoController.initialize();
    } catch (_) {
      return;
    }
    if (!mounted) {
      return;
    }
    await _syncPlayback();
  }

  Future<void> _syncPlayback() async {
    try {
      if (!widget.isActive || _isManuallyPaused) {
        await _videoController.pause();
        return;
      }
      await _videoController.play();
    } catch (_) {
      return;
    }
  }

  Future<void> _togglePlayback() async {
    if (!widget.isActive) {
      return;
    }

    final state = _videoController.state.value;
    if (!state.isInitialized || state.hasError) {
      return;
    }

    setState(() {
      _isManuallyPaused = !_isManuallyPaused;
    });

    await _syncPlayback();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void _handleDoubleTapLike() {
    _likeOverlayTimer?.cancel();

    setState(() {
      _showBurstHeart = true;
    });

    ref.read(feedNotifierProvider.notifier).like(widget.item.id);

    _likeOverlayTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showBurstHeart = false;
      });
    });
  }

  void _simulateDebugBuffering() {
    if (!kDebugMode || !widget.isActive) {
      return;
    }

    _debugBufferingTimer?.cancel();
    setState(() {
      _showDebugBuffering = true;
    });

    _debugBufferingTimer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showDebugBuffering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final burstHeartHalfSize = _BurstHeart.size / 2;
    final burstHeartLeft =
        ((_doubleTapPosition?.dx ?? screenSize.width / 2) - burstHeartHalfSize)
            .clamp(16.0, screenSize.width - _BurstHeart.size - 16.0);
    final burstHeartTop =
        ((_doubleTapPosition?.dy ?? screenSize.height / 2) - burstHeartHalfSize)
            .clamp(16.0, screenSize.height - _BurstHeart.size - 16.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlayback,
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTapLike,
      onLongPress: kDebugMode ? _simulateDebugBuffering : null,
      child: ColoredBox(
        color: FeedPage.pageBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _SceneBackground(item: widget.item),
            Positioned.fill(
              child: ValueListenableBuilder<FeedVideoState>(
                valueListenable: _videoController.state,
                builder: (context, videoState, child) {
                  if (videoState.hasError) {
                    return const SizedBox.expand();
                  }

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 240),
                    opacity: videoState.isInitialized ? 1 : 0,
                    child: _videoController.buildView(),
                  );
                },
              ),
            ),
            const _TopFade(),
            const _BottomFade(),
            ValueListenableBuilder<FeedVideoState>(
              valueListenable: _videoController.state,
              builder: (context, videoState, child) {
                final showLoader =
                    widget.isActive &&
                    !videoState.hasError &&
                    !videoState.isInitialized;

                if (!showLoader) {
                  return const SizedBox.shrink();
                }

                return const Center(
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0x66FFFFFF),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder<FeedVideoState>(
              valueListenable: _videoController.state,
              builder: (context, videoState, child) {
                final showBufferingIndicator =
                    widget.isActive &&
                    !videoState.hasError &&
                    ((videoState.isInitialized && videoState.isBuffering) ||
                        _showDebugBuffering);

                if (!showBufferingIndicator) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  left: 14,
                  right: 14,
                  bottom: widget.bottomNavigationHeight + 4,
                  child: const _BufferingPulseBar(),
                );
              },
            ),
            ValueListenableBuilder<FeedVideoState>(
              valueListenable: _videoController.state,
              builder: (context, videoState, child) {
                if (!videoState.hasError) {
                  return const SizedBox.shrink();
                }

                return _ErrorBadge(
                  topOffset: widget.topOverlayHeight + 12,
                  message:
                      videoState.errorDescription ?? 'Unable to load video',
                );
              },
            ),
            if (_showBurstHeart)
              Positioned(
                left: burstHeartLeft,
                top: burstHeartTop,
                child: const IgnorePointer(child: _BurstHeart()),
              ),
            if (_isManuallyPaused) const Center(child: _PausedBadge()),
            if (widget.isLoadingMore)
              Positioned(
                right: 14,
                bottom: widget.bottomNavigationHeight + 18,
                child: const _FeedPaginationBadge(
                  icon: Icons.downloading_rounded,
                  label: 'Loading more',
                ),
              ),
            if (widget.paginationError != null && widget.isActive)
              Positioned(
                left: 14,
                right: 92,
                bottom: widget.bottomNavigationHeight + 26,
                child: _FeedPaginationBadge(
                  icon: Icons.wifi_tethering_error_rounded,
                  label: widget.paginationError!,
                  tone: const Color(0xD9411218),
                ),
              ),
            Positioned(
              right: 12,
              bottom: widget.bottomNavigationHeight + 52,
              child: _ActionRail(
                item: widget.item,
                onLikeTap: () {
                  ref
                      .read(feedNotifierProvider.notifier)
                      .toggleLike(widget.item.id);
                },
              ),
            ),
            Positioned(
              left: 14,
              right: 92,
              bottom: widget.bottomNavigationHeight + 26,
              child: _FeedMetadata(item: widget.item),
            ),
          ],
        ),
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
        const DecoratedBox(
          decoration: BoxDecoration(color: FeedPage.pageBackground),
        ),
        const Center(child: IgnorePointer(child: MutedTikTokLogo(size: 176))),
        if (item.videoThumbnailUrl.isNotEmpty)
          Positioned.fill(
            child: _PosterImage(
              source: item.videoThumbnailUrl,
              aspectRatio: item.videoAspectRatio,
            ),
          ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0x26000000)),
          ),
        ),
      ],
    );
  }
}

class _PosterImage extends StatelessWidget {
  const _PosterImage({required this.source, required this.aspectRatio});

  final String source;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    Widget frameBuilder(
      BuildContext context,
      Widget child,
      int? frame,
      bool wasSynchronouslyLoaded,
    ) {
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: wasSynchronouslyLoaded || frame != null ? 1 : 0,
        child: child,
      );
    }

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: fitForShortFormAspectRatio(aspectRatio),
        frameBuilder: frameBuilder,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox.shrink();
        },
      );
    }

    return Image.network(
      source,
      fit: fitForShortFormAspectRatio(aspectRatio),
      frameBuilder: frameBuilder,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
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

class _ErrorBadge extends StatelessWidget {
  const _ErrorBadge({required this.topOffset, required this.message});

  final double topOffset;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset,
      left: 14,
      right: 14,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xA9161616),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x29FFFFFF)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPaginationBadge extends StatelessWidget {
  const _FeedPaginationBadge({
    required this.icon,
    required this.label,
    this.tone = const Color(0xD9101010),
  });

  final IconData icon;
  final String label;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x29FFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BurstHeart extends StatelessWidget {
  const _BurstHeart();

  static const double size = 112;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color(0x55FF2D55), blurRadius: 26, spreadRadius: 2),
        ],
      ),
      child: const Icon(Icons.favorite, size: size, color: Color(0xFFFF4B73)),
    );
  }
}

class _PausedBadge extends StatelessWidget {
  const _PausedBadge();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.play_arrow_rounded,
      size: 78,
      color: Colors.white,
      shadows: FeedPage.overlayIconShadows,
    );
  }
}

class _BufferingPulseBar extends StatefulWidget {
  const _BufferingPulseBar();

  @override
  State<_BufferingPulseBar> createState() => _BufferingPulseBarState();
}

class _BufferingPulseBarState extends State<_BufferingPulseBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1280),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Color(0x22FFFFFF)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final moveT = Curves.easeInOut.transform(_controller.value);
                  final pulseT =
                      1 -
                      ((_controller.value - 0.5).abs() / 0.5).clamp(0.0, 1.0);
                  final segmentWidth =
                      36 + ((84 - 36) * pulseT).clamp(0.0, 84.0);
                  final left =
                      (constraints.maxWidth - segmentWidth).clamp(
                        0.0,
                        constraints.maxWidth,
                      ) *
                      moveT;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: left,
                        width: segmentWidth,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x99FFFFFF),
                                blurRadius: 10,
                                spreadRadius: 0.4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActionRail extends StatelessWidget {
  const _ActionRail({required this.item, required this.onLikeTap});

  final FeedItem item;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AvatarAction(item: item),
          const SizedBox(height: 12),
          _ActionButton(
            icon: Icons.favorite,
            count: item.likeCount,
            color: item.isLiked ? FeedPage.likeColor : Colors.white,
            onTap: onLikeTap,
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: CupertinoIcons.chat_bubble_fill,
            count: item.commentCount,
            color: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: Icons.bookmark,
            count: item.bookmarkCount,
            color: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 14),
          _ActionButton(
            icon: CupertinoIcons.arrowshape_turn_up_right_fill,
            count: item.shareCount,
            color: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _MusicDisc(item: item),
        ],
      ),
    );
  }
}

class _AvatarAction extends StatelessWidget {
  const _AvatarAction({required this.item});

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
                shadows: FeedPage.overlayIconShadows,
              ),
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
    required this.onTap,
  });

  final IconData icon;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
            shadows: FeedPage.overlayIconShadows,
          ),
          const SizedBox(height: 4),
          Text(
            _formatSocialCount(count),
            style: const TextStyle(
              color: Color(0xF0FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              shadows: FeedPage.overlayIconShadows,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatSocialCount(int count) {
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

class _MusicDisc extends StatelessWidget {
  const _MusicDisc({required this.item});

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
          item.originalTrackLabel,
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
            if (item.authorIsVerified) ...[
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
