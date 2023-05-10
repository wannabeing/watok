import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/videos/view_models/video_timeline_vm.dart';
import 'package:watok/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  final PageController _pageController = PageController();

  int _itemCount = 0; // 비디오 개수

  // 비디오 끝났을 때 다음 비디오를 실행하는 함수
  void _onVideoFinished() {
    return;
    _pageController.nextPage(
      duration: const Duration(
        milliseconds: 150,
      ),
      curve: Curves.linear,
    );
  }

  // 페이지 변경 함수
  void _onPageChange(page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 150,
      ),
      curve: Curves.linear,
    );
    // 마지막 비디오일 경우, 비디오 더 가져오기
    if (page == _itemCount - 1) {
      ref.watch(timelineProvider.notifier).nextVideos();
    }
  }

  // 새로고침 함수
  Future<void> _onRefresh() async {
    return await ref.read(timelineProvider.notifier).refreshVideos();
  }

  // 비디오 없을 때
  Widget _videoIsEmpty() {
    return const Center(
        child: Text(
      "업로드된 비디오가 존재하지 않습니다.",
      style: TextStyle(
        color: Colors.white,
        fontSize: Sizes.size18,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timelineProvider에서 비디오 가져옴
    return ref.watch(timelineProvider).when(
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
          data: (videoList) {
            _itemCount = videoList.length; // 비디오 개수 초기화
            if (videoList.isEmpty) return _videoIsEmpty(); // 비디오가 없을 경우
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: Theme.of(context).primaryColor,
              edgeOffset: 20,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: videoList.length,
                onPageChanged: _onPageChange,
                itemBuilder: (context, index) {
                  final video = videoList[index];
                  return VideoPostScreen(
                    video: video, // 비디오 데이터
                    index: index, // 몇번째 화면인지
                    onVideoFinished: _onVideoFinished, // 비디오가 끝났을 때 실행할 함수
                  );
                },
              ),
            );
          },
        );
  }
}
