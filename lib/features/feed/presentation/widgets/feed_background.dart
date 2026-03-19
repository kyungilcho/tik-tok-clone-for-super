import 'package:flutter/material.dart';

import '../../domain/feed_item.dart';
import '../../../shared/presentation/widgets/muted_tiktok_logo.dart';
import '../video/feed_video_controller.dart';
import 'feed_page_tokens.dart';

class FeedSceneBackground extends StatelessWidget {
  const FeedSceneBackground({required this.item, super.key});

  final FeedItem item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(color: FeedPageTokens.pageBackground),
        ),
        const Center(child: IgnorePointer(child: MutedTikTokLogo(size: 176))),
        if (item.videoThumbnailUrl.isNotEmpty)
          Positioned.fill(
            child: FeedPosterImage(
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

class FeedPosterImage extends StatelessWidget {
  const FeedPosterImage({
    required this.source,
    required this.aspectRatio,
    super.key,
  });

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

class FeedTopFade extends StatelessWidget {
  const FeedTopFade({super.key});

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

class FeedBottomFade extends StatelessWidget {
  const FeedBottomFade({super.key});

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
