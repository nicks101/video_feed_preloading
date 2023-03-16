part of 'video_bloc.dart';

abstract class VideoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetVideosFromApi extends VideoEvent {}

class SetLoading extends VideoEvent {}

class OnVideoChanged extends VideoEvent {
  final int index;

  OnVideoChanged({required this.index});

  @override
  List<Object> get props => [index];
}
