import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/constants/width_types.dart';
import 'package:watok/features/videos/models/video_model.dart';
import 'package:watok/features/videos/view_models/video_config_vm.dart';
import 'package:watok/features/videos/views/widgets/video_comments.dart';
import 'package:watok/features/videos/views/widgets/video_icon.dart';
import 'package:watok/features/videos/views/widgets/video_like.dart';

class VideoPostScreen extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;
  final VideoModel video;

  const VideoPostScreen({
    super.key,
    required this.video,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  VideoPostScreenState createState() => VideoPostScreenState();
}

class VideoPostScreenState extends ConsumerState<VideoPostScreen>
    with SingleTickerProviderStateMixin {
  bool _isClick = false;
  bool _isMuted = false;

  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;

  void _onVideoChange() {
    // 비디오가 초기화되고, 비디오가 끝나면 onVideoFinished() 함수 실행
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  Future<void> _initVideoPlayer() async {
    /* 로컬에 있는 영상 사용할 때
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/goodhair.mp4");
    */
    _videoPlayerController =
        VideoPlayerController.network(widget.video.fileUrl);
    await _videoPlayerController.initialize(); // 비디오 초기화
    await _videoPlayerController.setLooping(true); // 반복 재생
    await _videoPlayerController.play();

    // 웹으로 컴파일되었다면 음소거
    if (kIsWeb) {
      await _videoPlayerController.setVolume(0.0);
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) async {
    // 위젯이 마운트되지 않았다면 아무작업도 하지 않음
    if (!mounted) return;

    // 현재 영상이 화면 전체를 덮고 있고, 일시정지 상태가 아니며, 영상이 멈춰 있으면 재생
    if (info.visibleFraction == 1 &&
        !_isClick &&
        !_videoPlayerController.value.isPlaying) {
      await _videoPlayerController.play();
    }
    // 다른 화면전환을 했는데도, 영상이 재생 중이면 영상정지
    if (info.visibleFraction == 0 && _videoPlayerController.value.isPlaying) {
      _onPlayStop();
    }
  }

  // 비디오 실행/정지 함수
  void _onPlayStop() async {
    if (!mounted) return;

    if (_videoPlayerController.value.isPlaying) {
      await _videoPlayerController.pause();
      await _animationController.reverse();
    } else {
      await _videoPlayerController.play();
      await _animationController.forward();
    }
    setState(() {
      _isClick = !_isClick;
    });
  }

  // 댓글창 아이콘 클릭했을 때
  void _onCommentsClick(BuildContext context) async {
    // 영상 멈추기
    if (_videoPlayerController.value.isPlaying) {
      _onPlayStop();
    }
    // 댓글창 보여주기
    await showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: WidthTypes.sm),
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 댓글창의 높이를 바꾸기 위해
      context: context,
      builder: (context) => const VideoComments(),
    );
    // 댓글창 닫으면 영상 재생
    _onPlayStop();
  }

  // 볼륨 음소거 설정 함수
  void _onTapVolume() {
    if (_isMuted) {
      _videoPlayerController.setVolume(1.0); // 음소거 해제
    } else {
      _videoPlayerController.setVolume(0.0); // 음소거 설정
    }
    _isMuted = !_isMuted;
    setState(() {});
  }

  // 볼륨 default 설정 함수
  void _initMute() {
    final muteSettings = ref.read(videoConfigProvider).muted;
    _isMuted = muteSettings; // 음소거 default 값 설정

    _videoPlayerController.setVolume(_isMuted ? 0.0 : 1.0); // 음소거 설정되어 있으면 초기화
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _initVideoPlayer(); // 영상 실행
    _initMute(); // 음소거 설정

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final video = widget.video;

    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 📕 영상
              Positioned.fill(
                child: _videoPlayerController.value.isInitialized
                    ? VideoPlayer(_videoPlayerController)
                    : Container(
                        color: Colors.black,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 4,
                          ),
                        ),
                      ),
              ),
              // 📕 영상 재생/멈춤 감지
              Positioned.fill(
                child: GestureDetector(
                  onTap: _onPlayStop,
                ),
              ),
              // 📕 영상 재생/멈춤 아이콘
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animationController.value,
                          child: child,
                        );
                      },
                      child: AnimatedOpacity(
                        opacity: _isClick ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size32,
                            vertical: Sizes.size24,
                          ),
                          decoration: const BoxDecoration(
                            // color: Colors.black.withOpacity(0.9),
                            borderRadius:
                                BorderRadius.all(Radius.circular(Sizes.size80)),
                          ),
                          child: FaIcon(
                            _videoPlayerController.value.isPlaying
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            size: Sizes.size60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 📕 업로드 유저 텍스트
              Positioned(
                bottom: 40,
                left: kIsWeb ? mediaWidth * 0.07 : 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@${video.uname}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      video.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size18,
                      ),
                    ),
                    Gaps.v10,
                    Text(
                      video.desc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        shadows: <Shadow>[
                          Shadow(
                            blurRadius: Sizes.size4,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 📕 아이콘들
              Positioned(
                bottom: 40,
                right: kIsWeb ? mediaWidth * 0.05 : 15,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _onTapVolume,
                      child: VideoIcon(
                        icon: _isMuted
                            ? FontAwesomeIcons.volumeXmark
                            : FontAwesomeIcons.volumeHigh,
                        text: "null",
                      ),
                    ),
                    Gaps.v24,
                    CircleAvatar(
                      maxRadius: Sizes.size28,
                      backgroundColor: Colors.grey.shade500,
                      foregroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/my-watok.appspot.com/o/avatars%2F${video.uid}?alt=media",
                      ),
                    ),
                    Gaps.v32,
                    VideoLikeWdgt(
                      video: video,
                    ),
                    Gaps.v24,
                    GestureDetector(
                      onTap: () => _onCommentsClick(context),
                      child: VideoIcon(
                        icon: FontAwesomeIcons.solidCommentDots,
                        text: "${video.comments}",
                      ),
                    ),
                    Gaps.v24,
                    const VideoIcon(
                      icon: FontAwesomeIcons.share,
                      text: "Share",
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
