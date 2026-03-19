import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/feed_providers.dart';
import '../../domain/feed_item.dart';
import '../video/feed_video_controller.dart';
import 'feed_action_rail.dart';
import 'feed_background.dart';
import 'feed_interaction_shells.dart';
import 'feed_metadata.dart';
import 'feed_overlays.dart';
import 'feed_page_tokens.dart';
import 'feed_progress_bar.dart';

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

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late final FeedVideoController _videoController;
  bool _isManuallyPaused = false;
  bool _showDebugBuffering = false;
  bool _showBurstHeart = false;
  Offset? _doubleTapPosition;
  bool _isScrubbing = false;
  Duration _scrubPosition = Duration.zero;
  bool _progressBarVisible = false;
  Timer? _autoHideTimer;

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
        _autoHideTimer?.cancel();
        _progressBarVisible = false;
        _isScrubbing = false;
      }
      unawaited(_syncPlayback());
    }
  }

  @override
  void dispose() {
    _debugBufferingTimer?.cancel();
    _autoHideTimer?.cancel();
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
    setState(() {
      _showBurstHeart = true;
    });

    ref.read(feedNotifierProvider.notifier).like(widget.item.id);
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

  void _startAutoHideTimer() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _progressBarVisible = false;
      });
    });
  }

  void _onScrubStart(Duration position) {
    _autoHideTimer?.cancel();
    setState(() {
      _progressBarVisible = true;
      _isScrubbing = true;
      _scrubPosition = position;
    });
  }

  void _onScrubUpdate(Duration position) {
    setState(() {
      _scrubPosition = position;
    });
  }

  void _onScrubEnd(Duration position) {
    unawaited(_videoController.seekTo(position));
    setState(() {
      _isScrubbing = false;
    });
    _startAutoHideTimer();
  }

  void _openProfilePage() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => FeedProfilePage(item: widget.item),
        ),
      ),
    );
  }

  void _openCommentsSheet(BuildContext context) {
    showFeedCommentsSheet(context, widget.item);
  }

  void _openShareSheet(BuildContext context) {
    showFeedShareSheet(context, widget.item);
  }

  void _openMusicSheet(BuildContext context) {
    showFeedMusicSheet(context, widget.item);
  }

  List<Widget> _buildVideoLayers() {
    return [
      FeedSceneBackground(item: widget.item),
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
      const FeedTopFade(),
      const FeedBottomFade(),
    ];
  }

  List<Widget> _buildStatusOverlays({
    required double burstHeartLeft,
    required double burstHeartTop,
  }) {
    return [
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
            child: const FeedBufferingPulseBar(),
          );
        },
      ),
      ValueListenableBuilder<FeedVideoState>(
        valueListenable: _videoController.state,
        builder: (context, videoState, child) {
          if (!videoState.hasError) {
            return const SizedBox.shrink();
          }

          return FeedErrorBadge(
            topOffset: widget.topOverlayHeight + 12,
            message: videoState.errorDescription ?? 'Unable to load video',
          );
        },
      ),
      if (_showBurstHeart)
        Positioned(
          left: burstHeartLeft,
          top: burstHeartTop,
          child: IgnorePointer(
            child: FeedBurstHeart(
              key: ValueKey(_doubleTapPosition),
              onComplete: () {
                if (!mounted) return;
                setState(() {
                  _showBurstHeart = false;
                });
              },
            ),
          ),
        ),
      if (_isManuallyPaused) const Center(child: FeedPausedBadge()),
      if (widget.isLoadingMore)
        Positioned(
          right: 14,
          bottom: widget.bottomNavigationHeight + 18,
          child: const FeedPaginationBadge(
            icon: Icons.downloading_rounded,
            label: 'Loading more',
          ),
        ),
      if (widget.paginationError != null && widget.isActive)
        Positioned(
          left: 14,
          right: 92,
          bottom: widget.bottomNavigationHeight + 26,
          child: FeedPaginationBadge(
            icon: Icons.wifi_tethering_error_rounded,
            label: widget.paginationError!,
            tone: const Color(0xD9411218),
          ),
        ),
    ];
  }

  Widget _buildActionRail() {
    return Positioned(
      right: 12,
      bottom: widget.bottomNavigationHeight + 52,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        onDoubleTap: () {},
        child: FeedActionRail(
          item: widget.item,
          onAvatarTap: _openProfilePage,
          onLikeTap: () {
            ref.read(feedNotifierProvider.notifier).toggleLike(widget.item.id);
          },
          onCommentTap: () => _openCommentsSheet(context),
          onBookmarkTap: () {
            ref
                .read(feedNotifierProvider.notifier)
                .toggleBookmark(widget.item.id);
          },
          onShareTap: () => _openShareSheet(context),
          onMusicTap: () => _openMusicSheet(context),
        ),
      ),
    );
  }

  Widget _buildMetadataSection() {
    return Positioned(
      left: 14,
      right: 92,
      bottom: widget.bottomNavigationHeight + 26,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isScrubbing
            ? ValueListenableBuilder<FeedVideoState>(
                key: const ValueKey('scrub-timestamp'),
                valueListenable: _videoController.state,
                builder: (context, videoState, _) {
                  return FeedScrubTimestamp(
                    position: _scrubPosition,
                    duration: videoState.duration,
                  );
                },
              )
            : FeedMetadata(
                key: const ValueKey('feed-metadata'),
                item: widget.item,
              ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: widget.bottomNavigationHeight,
      child: ValueListenableBuilder<FeedVideoState>(
        valueListenable: _videoController.state,
        builder: (context, videoState, _) {
          if (!videoState.isInitialized) {
            return const SizedBox.shrink();
          }

          return FeedVideoProgressBar(
            position: _isScrubbing ? _scrubPosition : videoState.position,
            duration: videoState.duration,
            isVisible: _progressBarVisible,
            isScrubbing: _isScrubbing,
            onScrubStart: _onScrubStart,
            onScrubUpdate: _onScrubUpdate,
            onScrubEnd: _onScrubEnd,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final burstHeartHalfSize = FeedBurstHeart.size / 2;
    final burstHeartLeft =
        ((_doubleTapPosition?.dx ?? screenSize.width / 2) - burstHeartHalfSize)
            .clamp(16.0, screenSize.width - FeedBurstHeart.size - 16.0);
    final burstHeartTop =
        ((_doubleTapPosition?.dy ?? screenSize.height / 2) - burstHeartHalfSize)
            .clamp(16.0, screenSize.height - FeedBurstHeart.size - 16.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _togglePlayback,
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTapLike,
      onLongPress: kDebugMode ? _simulateDebugBuffering : null,
      child: ColoredBox(
        color: FeedPageTokens.pageBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ..._buildVideoLayers(),
            ..._buildStatusOverlays(
              burstHeartLeft: burstHeartLeft,
              burstHeartTop: burstHeartTop,
            ),
            _buildActionRail(),
            _buildMetadataSection(),
            _buildProgressBar(),
          ],
        ),
      ),
    );
  }
}
