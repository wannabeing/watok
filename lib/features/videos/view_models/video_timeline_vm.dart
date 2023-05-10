import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/videos/models/video_model.dart';
import 'package:watok/features/videos/repos/video_repo.dart';

class TimeLineViewModel extends AsyncNotifier<List<VideoModel>> {
  late List<VideoModel> _videoList; // Video 리스트
  late VideoRepository _videoRepository;

  // 비디오 리스트 초기화
  @override
  FutureOr<List<VideoModel>> build() async {
    _videoRepository = ref.read(videoRepository);

    _videoList = await _getVideos();
    state = AsyncValue.data(_videoList);
    return _videoList;
  }

  // 비디오 모델 2개 가져오는 함수
  Future<List<VideoModel>> _getVideos({int? lastCreatedAt}) async {
    final snapshot = await _videoRepository.getVideos(
      lastCreatedAt: lastCreatedAt,
    );
    // 각각의 JSON을 VideoModel로 변환 후, 변수에 저장
    final videos = snapshot.docs.map(
      (doc) => VideoModel.fromJSON(
        json: doc.data(),
        videoId: doc.id,
      ),
    );

    return videos.toList();
  }

  // 다음 비디오 2개 가져오기
  Future<void> nextVideos() async {
    final nextVideos =
        await _getVideos(lastCreatedAt: _videoList.last.createdAt);
    state = AsyncValue.data([..._videoList, ...nextVideos]);
  }

  // 비디오 새로고침
  Future<void> refreshVideos() async {
    state = const AsyncValue.loading();

    final videos = await _getVideos();
    _videoList = videos;
    state = AsyncValue.data(videos);
  }
}

/* 
  View에서 사용할 수 있는 Provider
  expose(노출)할 ViewModel과
  그 ViewModel에 들어있는 데이터의 형식(Model)을 알려줌
*/
final timelineProvider =
    AsyncNotifierProvider<TimeLineViewModel, List<VideoModel>>(
  () => TimeLineViewModel(),
);
