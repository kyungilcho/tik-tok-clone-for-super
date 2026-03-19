import 'package:flutter/material.dart';

import 'feed_page_tokens.dart';
import 'feed_social_count.dart';

enum _FeedLikeAnimationMode { idle, liking, unliking }

class FeedLikeButton extends StatefulWidget {
  const FeedLikeButton({
    required this.count,
    required this.isLiked,
    required this.onTap,
    super.key,
  });

  final int count;
  final bool isLiked;
  final VoidCallback onTap;

  @override
  State<FeedLikeButton> createState() => _FeedLikeButtonState();
}

class _FeedLikeButtonState extends State<FeedLikeButton>
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
  _FeedLikeAnimationMode _mode = _FeedLikeAnimationMode.idle;
  late Color _fromColor;
  late Color _toColor;

  Color get _currentTargetColor =>
      widget.isLiked ? FeedPageTokens.likeColor : Colors.white;

  @override
  void initState() {
    super.initState();
    _fromColor = _currentTargetColor;
    _toColor = _currentTargetColor;
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 320),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            setState(() {
              _mode = _FeedLikeAnimationMode.idle;
            });
          }
        });
  }

  @override
  void didUpdateWidget(covariant FeedLikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLiked != widget.isLiked) {
      _fromColor = oldWidget.isLiked ? FeedPageTokens.likeColor : Colors.white;
      _toColor = _currentTargetColor;
      _mode = widget.isLiked
          ? _FeedLikeAnimationMode.liking
          : _FeedLikeAnimationMode.unliking;
      _controller.forward(from: 0);
    } else {
      _fromColor = _currentTargetColor;
      _toColor = _currentTargetColor;
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

  double _resolveIconScale(double t) {
    final motionScale = switch (_mode) {
      _FeedLikeAnimationMode.idle => 1.0,
      _FeedLikeAnimationMode.liking => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.86,
            end: 1.24,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 46,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.24,
            end: 0.96,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 24,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 0.96,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOutBack)),
          weight: 30,
        ),
      ]).transform(t),
      _FeedLikeAnimationMode.unliking => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 0.84,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 34,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 0.84,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 66,
        ),
      ]).transform(t),
    };

    return motionScale * (_isPressed ? 0.9 : 1.0);
  }

  Widget _buildIcon() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOut.transform(_controller.value);
        final iconColor = Color.lerp(_fromColor, _toColor, t)!;
        final iconScale = _resolveIconScale(_controller.value);
        final glowOpacity = switch (_mode) {
          _FeedLikeAnimationMode.liking => (1 - t) * 0.22,
          _FeedLikeAnimationMode.unliking => (1 - t) * 0.08,
          _FeedLikeAnimationMode.idle => 0.0,
        };
        final echoOpacity = switch (_mode) {
          _FeedLikeAnimationMode.liking => (1 - t) * 0.34,
          _ => 0.0,
        };

        return SizedBox(
          width: _iconBoxWidth,
          height: _iconBoxHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (glowOpacity > 0)
                Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: 0.72 + (t * 0.7),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: FeedPageTokens.likeColor.withValues(
                            alpha: glowOpacity,
                          ),
                          blurRadius: 22,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const SizedBox(width: 18, height: 18),
                  ),
                ),
              if (echoOpacity > 0)
                Transform.scale(
                  alignment: Alignment.bottomCenter,
                  scale: 0.74 + (t * 0.85),
                  child: Opacity(
                    opacity: echoOpacity,
                    child: const Icon(
                      Icons.favorite,
                      color: FeedPageTokens.likeColor,
                      size: _iconSize,
                    ),
                  ),
                ),
              Transform.scale(
                alignment: Alignment.bottomCenter,
                scale: iconScale,
                child: Icon(
                  Icons.favorite,
                  color: iconColor,
                  size: _iconSize,
                  shadows: FeedPageTokens.overlayIconShadows,
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
