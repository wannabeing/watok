import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/features/videos/models/video_model.dart';
import 'package:watok/features/videos/view_models/video_post_vm.dart';
import 'package:watok/features/videos/views/widgets/video_icon.dart';

class VideoLikeWdgt extends ConsumerStatefulWidget {
  final VideoModel video;
  const VideoLikeWdgt({
    super.key,
    required this.video,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoLikeWdgtState();
}

class _VideoLikeWdgtState extends ConsumerState<VideoLikeWdgt> {
  int _likes = 0;

  // 좋아요 클릭 함수
  Future<void> _onTapLike(bool videoLike) async {
    await ref.read(videoPostProvider(widget.video.vid).notifier).likeVideo();

    setState(() {
      if (videoLike) {
        _likes--;
      } else {
        _likes++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _likes = widget.video.likes;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(videoPostProvider(widget.video.vid)).when(
          data: (videoLike) {
            return GestureDetector(
              onTap: () => _onTapLike(videoLike),
              child: VideoIcon(
                icon: FontAwesomeIcons.solidHeart,
                text: "$_likes",
                selectedColor: videoLike ? Colors.red : Colors.white,
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "$error",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
  }
}
