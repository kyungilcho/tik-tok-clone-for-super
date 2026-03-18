import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class FeedVideoState {
  const FeedVideoState({
    this.isInitialized = false,
    this.isBuffering = false,
    this.hasError = false,
    this.errorDescription,
    this.videoSize = Size.zero,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final bool isInitialized;
  final bool isBuffering;
  final bool hasError;
  final String? errorDescription;
  final Size videoSize;
  final Duration position;
  final Duration duration;
}

abstract class FeedVideoController {
  ValueListenable<FeedVideoState> get state;

  Widget buildView();

  Future<void> initialize();

  Future<void> play();

  Future<void> pause();

  Future<void> seekTo(Duration position);

  Future<void> dispose();
}

typedef FeedVideoControllerFactory =
    FeedVideoController Function(String videoUrl);

FeedVideoState errorFeedVideoState(String message) {
  return FeedVideoState(hasError: true, errorDescription: message);
}

BoxFit fitForShortFormAspectRatio(double aspectRatio) {
  if (aspectRatio >= 0.8) {
    return BoxFit.contain;
  }

  return BoxFit.cover;
}
