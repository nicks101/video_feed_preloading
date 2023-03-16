import 'package:equatable/equatable.dart';

class VideoFeed extends Equatable {
  final String contentId;
  final String caption;
  final String thumbnail;
  final String url;
  final int views;
  final int likes;
  final String createdAt;

  const VideoFeed({
    required this.contentId,
    required this.caption,
    required this.thumbnail,
    required this.url,
    required this.views,
    required this.likes,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [contentId, caption, thumbnail, url, views, likes, createdAt];

  @override
  bool? get stringify => true;

  factory VideoFeed.fromJson(Map<String, dynamic> json) {
    return VideoFeed(
      contentId: json['contentId'],
      caption: json['caption'],
      thumbnail: json['thumbnail'],
      url: json['url'],
      views: json['views'],
      likes: json['likes'],
      createdAt: json['createdAt'],
    );
  }
}
