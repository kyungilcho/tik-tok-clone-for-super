import 'package:flutter/material.dart';

import 'feed_page_tokens.dart';

class FeedErrorBadge extends StatelessWidget {
  const FeedErrorBadge({
    required this.topOffset,
    required this.message,
    super.key,
  });

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

class FeedPaginationBadge extends StatelessWidget {
  const FeedPaginationBadge({
    required this.icon,
    required this.label,
    this.tone = const Color(0xD9101010),
    super.key,
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

class FeedBurstHeart extends StatefulWidget {
  const FeedBurstHeart({this.onComplete, super.key});

  static const double size = 112;

  final VoidCallback? onComplete;

  @override
  State<FeedBurstHeart> createState() => _FeedBurstHeartState();
}

class _FeedBurstHeartState extends State<FeedBurstHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _drift;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 75,
      ),
    ]).animate(_controller);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_controller);

    _drift = Tween<double>(begin: 0, end: -120)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _drift.value),
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.scale(
              scale: _scale.value,
              child: child,
            ),
          ),
        );
      },
      child: const Icon(
        Icons.favorite,
        size: FeedBurstHeart.size,
        color: Color(0xFFFF2D55),
        shadows: [
          Shadow(color: Color(0x55FF2D55), blurRadius: 24),
        ],
      ),
    );
  }
}

class FeedPausedBadge extends StatelessWidget {
  const FeedPausedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.play_arrow_rounded,
      size: 78,
      color: Colors.white,
      shadows: FeedPageTokens.overlayIconShadows,
    );
  }
}

class FeedBufferingPulseBar extends StatefulWidget {
  const FeedBufferingPulseBar({super.key});

  @override
  State<FeedBufferingPulseBar> createState() => _FeedBufferingPulseBarState();
}

class _FeedBufferingPulseBarState extends State<FeedBufferingPulseBar>
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
