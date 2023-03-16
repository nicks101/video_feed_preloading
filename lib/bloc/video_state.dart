part of 'video_bloc.dart';

class VideoState extends Equatable {
  const VideoState({
    required this.videoFeed,
    required this.controllers,
    required this.previousIndex,
    required this.isLoading,
  });

  final List<VideoFeed> videoFeed;
  final Map<int, VideoPlayerController> controllers;
  final int previousIndex;
  final bool isLoading;

  factory VideoState.initial() => const VideoState(
        previousIndex: 0,
        videoFeed: [],
        isLoading: false,
        controllers: {},
      );

  VideoState copyWith({
    List<VideoFeed>? videoFeed,
    Map<int, VideoPlayerController>? controllers,
    int? previousIndex,
    bool? isLoading,
  }) {
    return VideoState(
      videoFeed: videoFeed ?? this.videoFeed,
      controllers: controllers ?? this.controllers,
      previousIndex: previousIndex ?? this.previousIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  String toString() {
    return 'VideoState(videoFeed: $videoFeed, controllers: $controllers, previousIndex: $previousIndex, isLoading: $isLoading)';
  }

  @override
  List<Object> get props => [videoFeed, controllers, previousIndex, isLoading];
}
