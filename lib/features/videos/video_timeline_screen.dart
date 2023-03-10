import 'package:flutter/material.dart';
import 'package:watok/features/videos/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  final PageController _pageController = PageController();

  int _itemCount = 3;

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

  void _onPageChange(page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 150,
      ),
      curve: Curves.linear,
    );
    if (page == _itemCount - 1) {
      setState(() {
        _itemCount += 3;
      });
    }
  }

  // 새로고침 함수
  Future<void> _onRefresh() {
    // 원래는 여기에 API 요청을 넣어야함
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor,
      edgeOffset: 20,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _itemCount,
        onPageChanged: _onPageChange,
        itemBuilder: (context, index) => VideoPostScreen(
          index: index, // 몇번째 화면인지
          onVideoFinished: _onVideoFinished, // 비디오가 끝났을 때 실행할 함수
        ),
      ),
    );
  }
}
