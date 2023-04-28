import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'package:watok/features/videos/view_models/timeline_view_model.dart';

class VideoArgs {
  final XFile video; // 녹화한 영상 파일
  final bool isPicked; // 내 디바이스 갤러리에서 가져왔는지 (false: 안가져왔음)

  VideoArgs({
    required this.video,
    required this.isPicked,
  });
}

class VideoPreviewScreen extends ConsumerStatefulWidget {
  static String route = "/preview";
  final VideoArgs videoArgs;

  const VideoPreviewScreen({
    super.key,
    required this.videoArgs,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isSaved = false; // 녹화한 영상 저장했는지 (false: 저장 안했음)
  late final bool _isPicked =
      widget.videoArgs.isPicked; // 내 디바이스 갤러리에서 가져왔는지 (false: 안가져왔음)

  // 녹화한 영상 실행 함수
  Future<void> _playVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoArgs.video.path));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  // 디바이스에 녹화영상 저장하는 함수
  Future<void> _saveDevice() async {
    if (_isSaved) return; // 중복 저장 방지
    await GallerySaver.saveVideo(
      widget.videoArgs.video.path,
      albumName: "와톡",
    ); // 녹화영상 디바이스에 저장
    _isSaved = true; // 녹화한 영상 저장상태 설정
    setState(() {});
  }

  // 영상 업로드 함수
  void _uploadVideo() {
    ref.read(timelineProvider.notifier).addVideoModel();
  }

  @override
  void initState() {
    super.initState();
    _playVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("test"),
        actions: [
          if (!_isPicked)
            IconButton(
              onPressed: _saveDevice,
              icon: _isSaved
                  ? const FaIcon(FontAwesomeIcons.check)
                  : const FaIcon(FontAwesomeIcons.download),
            ),
          IconButton(
            onPressed:
                ref.watch(timelineProvider).isLoading ? () {} : _uploadVideo,
            icon: ref.watch(timelineProvider).isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                : const FaIcon(FontAwesomeIcons.arrowRight),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
