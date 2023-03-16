import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_feed_app/bloc/video_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(GetVideosFromApi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          return PageView.builder(
            itemCount: state.videoFeed.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) =>
                BlocProvider.of<VideoBloc>(context, listen: false)
                    .add(OnVideoChanged(index: index)),
            itemBuilder: (context, index) {
              return VideoWidget(
                isLoading: false,
                controller: state.controllers[index]!,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}

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
