import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'feed_video_controller.dart';

class VideoPlayerFeedVideoController implements FeedVideoController {
  VideoPlayerFeedVideoController(String videoUrl)
    : _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl)),
      _state = ValueNotifier(const FeedVideoState()) {
    _controller.addListener(_syncState);
  }

  final VideoPlayerController _controller;
  final ValueNotifier<FeedVideoState> _state;

  @override
  ValueListenable<FeedVideoState> get state => _state;

  @override
  Widget buildView() {
    final value = _controller.value;
    if (!value.isInitialized) {
      return const SizedBox.expand();
    }

    final aspectRatio = value.size.height == 0
        ? 9 / 16
        : value.size.width / value.size.height;

    return ClipRect(
      child: ColoredBox(
        color: Colors.black,
        child: FittedBox(
          fit: fitForShortFormAspectRatio(aspectRatio),
          child: SizedBox(
            width: value.size.width,
            height: value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> initialize() async {
    try {
      await _controller.initialize();
      await _controller.setLooping(true);
      _syncState();
    } catch (error) {
      _state.value = errorFeedVideoState(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> pause() => _controller.pause();

  @override
  Future<void> play() => _controller.play();

  @override
  Future<void> seekTo(Duration position) => _controller.seekTo(position);

  @override
  Future<void> dispose() async {
    _controller.removeListener(_syncState);
    _state.dispose();
    await _controller.dispose();
  }

  void _syncState() {
    final value = _controller.value;
    _state.value = FeedVideoState(
      isInitialized: value.isInitialized,
      isBuffering: value.isBuffering,
      hasError: value.hasError,
      errorDescription: value.errorDescription,
      videoSize: value.size,
      position: value.position,
      duration: value.duration,
    );
  }
}
