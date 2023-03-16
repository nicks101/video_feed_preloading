import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../api_data.dart';
import '../models/video_feed.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState.initial()) {
    on<SetLoading>(_onSetLoading);
    on<GetVideosFromApi>(_onGetVideosFromApi);
    on<OnVideoChanged>(_onVideoChanged);
  }

  void _onSetLoading(
    SetLoading event,
    Emitter<VideoState> emit,
  ) =>
      emit(state.copyWith(isLoading: true));

  void _onGetVideosFromApi(
    GetVideosFromApi event,
    Emitter<VideoState> emit,
  ) async {
    final videoResponse =
        (videoFeedResponse['data'] as List<Map<String, dynamic>>)
            .map((e) => VideoFeed.fromJson(e))
            .toList();

    emit(state.copyWith(
      videoFeed: List.of(state.videoFeed)..addAll(videoResponse),
    ));

    await _initializeControllerAtIndex(0);

    _playControllerAtIndex(0);

    await _initializeControllerAtIndex(1);

    emit(state.copyWith(isLoading: false));
  }

  void _onVideoChanged(
    OnVideoChanged event,
    Emitter<VideoState> emit,
  ) async {
    if (event.index > state.previousIndex) {
      _playNext(event.index);
    } else {
      _playPrevious(event.index);
    }

    emit(state.copyWith(previousIndex: event.index));
  }

  void _playNext(int index) {
    _stopControllerAtIndex(index - 1);

    _disposeControllerAtIndex(index - 2);

    _playControllerAtIndex(index);

    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    _stopControllerAtIndex(index + 1);

    _disposeControllerAtIndex(index + 2);

    _playControllerAtIndex(index);

    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (state.videoFeed.length > index && index >= 0) {
      final VideoPlayerController controller =
          VideoPlayerController.network(state.videoFeed[index].url);

      emit(state.copyWith(
        controllers: {...state.controllers, index: controller},
      ));

      await controller.initialize();
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.videoFeed.length > index && index >= 0) {
      final VideoPlayerController? controller = state.controllers[index];

      controller?.play();
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.videoFeed.length > index && index >= 0) {
      final VideoPlayerController? controller = state.controllers[index];
      controller?.pause();
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.videoFeed.length > index && index >= 0) {
      final VideoPlayerController? controller = state.controllers[index];

      controller?.dispose();

      if (controller != null) {
        emit(state.copyWith(
          controllers: {...state.controllers}..remove(index),
        ));
      }
    }
  }
}
