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
  });

  final bool isInitialized;
  final bool isBuffering;
  final bool hasError;
  final String? errorDescription;
  final Size videoSize;
}

abstract class FeedVideoController {
  ValueListenable<FeedVideoState> get state;

  Widget buildView();

  Future<void> initialize();

  Future<void> play();

  Future<void> pause();

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
