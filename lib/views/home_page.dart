import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_feed_app/fake_data.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<VideoFeedResponse> data = [];
  Map<int, VideoPlayerController> controllers = {};

  int previousIndex = 0;

  @override
  void initState() {
    super.initState();
    (myResponse['data'] as List<Map<String, dynamic>>).forEach((element) {
      data.add(VideoFeedResponse.fromJson(element));
    });

    final controller = VideoPlayerController.network(data[0].url);
    controllers[0] = controller;

    controllers[0]?.initialize().then((_) {
      setState(() {});
      controllers[0]?.setLooping(true);
      controllers[0]?.play();
    });

    _initializeControllerAtIndex(1);
    _initializeControllerAtIndex(2);
  }

  @override
  void dispose() {
    super.dispose();
    controllers.forEach((_, value) {
      value.dispose();
    });
  }

  Future _initializeControllerAtIndex(int index) async {
    if (data.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController _controller =
          VideoPlayerController.network(data[index].url);

      /// Add to [controllers] list
      controllers[index] = _controller;

      /// Initialize
      await _controller.initialize();

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (data.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = controllers[index];

      /// Play controller
      controller?.setLooping(true);
      controller?.play();

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (data.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController controller = controllers[index]!;

      /// Pause
      controller.pause();

      // /// Reset postiton to beginning
      // _controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (data.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = controllers[index];

      /// Dispose controller
      controller?.dispose();

      if (controller == null) return;

      controllers.remove(controller);

      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  void _playNext(int index) {
    _initializeControllerAtIndex(index + 1)
        .then((_) => _initializeControllerAtIndex(index + 2));

    _stopControllerAtIndex(index - 1);

    _playControllerAtIndex(index);

    _disposeControllerAtIndex(index - 3);
  }

  void _playPrevious(int index) {
    _initializeControllerAtIndex(index - 1)
        .then((_) => _initializeControllerAtIndex(index - 2));

    _stopControllerAtIndex(index + 1);

    _playControllerAtIndex(index);

    _disposeControllerAtIndex(index + 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: data.length,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          if (index == previousIndex) return;

          if (index > previousIndex) {
            _playNext(index);
          } else {
            _playPrevious(index);
          }

          previousIndex = index;
        },
        itemBuilder: (context, index) {
          return VideoWidget(
            isLoading: controllers[index]?.value.isBuffering ?? false,
            controller: controllers[index]!,
            index: index,
          );
        },
      ),
    );
  }
}

/// Custom Feed Widget consisting video
class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.index,
  });

  final bool isLoading;
  final VideoPlayerController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 70),
        Text('Video $index'),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            },
            child: VideoPlayer(controller),
          ),
        ),
        AnimatedCrossFade(
          alignment: Alignment.bottomCenter,
          sizeCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 400),
          firstChild: const Padding(
            padding: EdgeInsets.all(10.0),
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 8,
            ),
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState:
              isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ],
    );
  }
}
