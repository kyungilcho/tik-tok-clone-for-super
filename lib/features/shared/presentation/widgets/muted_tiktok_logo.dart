import 'package:flutter/material.dart';

class MutedTikTokLogo extends StatelessWidget {
  const MutedTikTokLogo({this.size = 148, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 20,
      height: size + 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _LogoLayer(
            size: size,
            iconColor: const Color(0xFF2C2C2C),
            offset: const Offset(-6, 6),
          ),
          _LogoLayer(
            size: size,
            iconColor: const Color(0xFF4A4A4A),
            offset: const Offset(6, -6),
          ),
          _LogoLayer(
            size: size,
            iconColor: const Color(0xFFD9D9D9),
            offset: Offset.zero,
          ),
        ],
      ),
    );
  }
}

class _LogoLayer extends StatelessWidget {
  const _LogoLayer({
    required this.size,
    required this.iconColor,
    required this.offset,
  });

  final double size;
  final Color iconColor;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Icon(Icons.music_note_rounded, size: size, color: iconColor),
    );
  }
}
