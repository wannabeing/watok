import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/videos/widgets/video_icon.dart';

class VideoPostScreen extends StatefulWidget {
  final Function onVideoFinished;
  final int index;
  const VideoPostScreen({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPostScreen> createState() => _VideoPostScreenState();
}

class _VideoPostScreenState extends State<VideoPostScreen>
    with SingleTickerProviderStateMixin {
  bool _isClick = false;

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

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/test.mp4");
    await _videoPlayerController.initialize(); // 비디오 초기화
    await _videoPlayerController.setLooping(true); // 반복 재생

    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // 현재 영상이 화면 전체를 덮고 있고, 끝났으면 다음 영상을 재생
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  // 비디오 실행/정지 함수
  void _onPlayStop() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isClick = !_isClick;
    });
  }

  @override
  void initState() {
    super.initState();

    _initVideoPlayer(); // 영상 실행

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
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          // 📕 영상
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
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
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Sizes.size80)),
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
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "@업로드계정",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v16,
                Text(
                  "제목이 들어가야죠",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                Text(
                  "#123 #456 #789 #alsdkfjewll",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 15,
            child: Column(
              children: const [
                CircleAvatar(
                  maxRadius: Sizes.size28,
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/79440384"),
                  child: Text("닉넴"),
                ),
                Gaps.v32,
                VideoIcon(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "3.3M",
                ),
                Gaps.v24,
                VideoIcon(
                  icon: FontAwesomeIcons.solidCommentDots,
                  text: "22",
                ),
                Gaps.v24,
                VideoIcon(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
