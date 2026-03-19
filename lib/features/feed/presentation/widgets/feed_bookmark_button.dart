import 'package:flutter/material.dart';

import 'feed_page_tokens.dart';
import 'feed_social_count.dart';

enum _FeedBookmarkAnimationMode { idle, saving, unsaving }

class FeedBookmarkButton extends StatefulWidget {
  const FeedBookmarkButton({
    required this.count,
    required this.isBookmarked,
    required this.onTap,
    super.key,
  });

  final int count;
  final bool isBookmarked;
  final VoidCallback onTap;

  @override
  State<FeedBookmarkButton> createState() => _FeedBookmarkButtonState();
}

class _FeedBookmarkButtonState extends State<FeedBookmarkButton>
    with SingleTickerProviderStateMixin {
  static const _buttonWidth = 54.0;
  static const _buttonHeight = 62.0;
  static const _iconBoxWidth = 46.0;
  static const _iconBoxHeight = 44.0;
  static const _iconSize = 32.0;
  static const _countSlotHeight = 14.0;
  static const _tapSlop = 20.0;

  late final AnimationController _controller;
  Offset? _downPosition;
  bool _isPressed = false;
  _FeedBookmarkAnimationMode _mode = _FeedBookmarkAnimationMode.idle;

  Color get _targetColor =>
      widget.isBookmarked ? FeedPageTokens.bookmarkColor : Colors.white;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 280),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              _mode = _FeedBookmarkAnimationMode.idle;
            });
          }
        });
  }

  @override
  void didUpdateWidget(covariant FeedBookmarkButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isBookmarked != widget.isBookmarked) {
      _mode = widget.isBookmarked
          ? _FeedBookmarkAnimationMode.saving
          : _FeedBookmarkAnimationMode.unsaving;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool isPressed) {
    if (_isPressed == isPressed || !mounted) {
      return;
    }

    setState(() {
      _isPressed = isPressed;
    });
  }

  void _handlePointerDown(PointerDownEvent event) {
    _downPosition = event.localPosition;
    _setPressed(true);
  }

  void _handlePointerUp(PointerUpEvent event) {
    final downPosition = _downPosition;
    _downPosition = null;
    _setPressed(false);

    if (downPosition == null) {
      return;
    }

    if ((event.localPosition - downPosition).distance < _tapSlop) {
      widget.onTap();
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _downPosition = null;
    _setPressed(false);
  }

  double _resolveScale(double t) {
    final motionScale = switch (_mode) {
      _FeedBookmarkAnimationMode.idle => 1.0,
      _FeedBookmarkAnimationMode.saving => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.9,
            end: 1.12,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 48,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.12,
            end: 0.97,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 22,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 0.97,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 30,
        ),
      ]).transform(t),
      _FeedBookmarkAnimationMode.unsaving => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 0.9,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 38,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 0.9,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 62,
        ),
      ]).transform(t),
    };

    return motionScale * (_isPressed ? 0.92 : 1.0);
  }

  double _resolveLift(double t) {
    return switch (_mode) {
      _FeedBookmarkAnimationMode.saving => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.0,
            end: -3.0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: -3.0,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
      ]).transform(t),
      _FeedBookmarkAnimationMode.unsaving => Tween(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut)).transform(t),
      _FeedBookmarkAnimationMode.idle => 0.0,
    };
  }

  Widget _buildIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_controller.value);
        final scale = _resolveScale(_controller.value);
        final lift = _resolveLift(_controller.value);
        final glowOpacity = switch (_mode) {
          _FeedBookmarkAnimationMode.saving => (1 - t) * 0.2,
          _FeedBookmarkAnimationMode.unsaving => (1 - t) * 0.06,
          _FeedBookmarkAnimationMode.idle => 0.0,
        };
        final fillOpacity = widget.isBookmarked
            ? 1.0
            : (_mode == _FeedBookmarkAnimationMode.unsaving ? 1 - t : 0.0);
        final outlineColor = Color.lerp(Colors.white, _targetColor, t)!;

        return SizedBox(
          width: _iconBoxWidth,
          height: _iconBoxHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (glowOpacity > 0)
                Transform.translate(
                  offset: Offset(0, lift),
                  child: Transform.scale(
                    alignment: Alignment.bottomCenter,
                    scale: 0.8 + (t * 0.45),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: FeedPageTokens.bookmarkColor.withValues(
                              alpha: glowOpacity,
                            ),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const SizedBox(width: 18, height: 18),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(0, lift),
                child: Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (fillOpacity > 0)
                        Opacity(
                          opacity: fillOpacity,
                          child: const Icon(
                            Icons.bookmark,
                            size: _iconSize,
                            color: FeedPageTokens.bookmarkColor,
                            shadows: FeedPageTokens.overlayIconShadows,
                          ),
                        ),
                      Icon(
                        widget.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline_rounded,
                        color: outlineColor,
                        size: _iconSize,
                        shadows: FeedPageTokens.overlayIconShadows,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCount() {
    return SizedBox(
      height: _countSlotHeight,
      child: Text(
        formatSocialCount(widget.count),
        style: const TextStyle(
          color: Color(0xF0FFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          shadows: FeedPageTokens.overlayIconShadows,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerCancel,
      child: SizedBox(
        width: _buttonWidth,
        height: _buttonHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 0,
              left: (_buttonWidth - _iconBoxWidth) / 2,
              child: _buildIcon(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildCount(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
