import 'package:flutter/material.dart';

import 'muted_tiktok_logo.dart';

class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    required this.title,
    this.topPadding = 0,
    this.bottomPadding = 0,
    super.key,
  });

  final String title;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF070707),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          topPadding + 24,
          24,
          bottomPadding + 24,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MutedTikTokLogo(),
              const SizedBox(height: 28),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0x8FFFFFFF),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
