import 'package:flutter/material.dart';

import 'feed_page_tokens.dart';

class FeedScrubTimestamp extends StatelessWidget {
  const FeedScrubTimestamp({
    required this.position,
    required this.duration,
    super.key,
  });

  final Duration position;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatDuration(position),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: -0.5,
            shadows: FeedPageTokens.overlayIconShadows,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2, left: 6, right: 6),
          child: Text(
            '/',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1,
              shadows: FeedPageTokens.overlayIconShadows,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Text(
            formatDuration(duration),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1,
              shadows: FeedPageTokens.overlayIconShadows,
            ),
          ),
        ),
      ],
    );
  }
}

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class FeedVideoProgressBar extends StatelessWidget {
  const FeedVideoProgressBar({
    required this.position,
    required this.duration,
    required this.isVisible,
    required this.isScrubbing,
    required this.onScrubStart,
    required this.onScrubUpdate,
    required this.onScrubEnd,
    super.key,
  });

  final Duration position;
  final Duration duration;
  final bool isVisible;
  final bool isScrubbing;
  final ValueChanged<Duration> onScrubStart;
  final ValueChanged<Duration> onScrubUpdate;
  final ValueChanged<Duration> onScrubEnd;

  double get _progress {
    if (duration.inMilliseconds == 0) return 0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  Duration _positionFromDx(double dx, double width) {
    if (width <= 0 || duration.inMilliseconds == 0) return Duration.zero;
    final ratio = (dx / width).clamp(0.0, 1.0);
    return Duration(
      milliseconds: (ratio * duration.inMilliseconds).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = isScrubbing ? 4.0 : 2.0;
    final handleSize = isScrubbing ? 14.0 : 8.0;
    final handleOverflow = (handleSize - barHeight) / 2;
    const hitAreaHeight = 40.0;

    return AnimatedOpacity(
      opacity: isVisible || isScrubbing ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        height: hitAreaHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (details) {
                final nextPosition = _positionFromDx(
                  details.localPosition.dx,
                  width,
                );
                onScrubStart(nextPosition);
              },
              onHorizontalDragUpdate: (details) {
                final nextPosition = _positionFromDx(
                  details.localPosition.dx,
                  width,
                );
                onScrubUpdate(nextPosition);
              },
              onHorizontalDragEnd: (details) {
                onScrubEnd(position);
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: handleOverflow,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      height: barHeight,
                      child: CustomPaint(
                        painter: _ProgressBarPainter(progress: _progress),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: (_progress * width) - handleSize / 2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      width: handleSize,
                      height: handleSize,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0x55FFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    final foregroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width * progress, size.height),
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
