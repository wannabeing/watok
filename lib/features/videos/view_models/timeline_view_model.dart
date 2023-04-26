import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/videos/models/video_model.dart';

// VideoModel[]을 expose하는 클래스
class TimeLineViewModel extends AsyncNotifier<List<VideoModel>> {
  // Video 리스트
  List<VideoModel> _list = [
    VideoModel(title: "first"),
  ];

  // Video 추가하는 함수
  void addVideoModel() async {
    state = const AsyncValue.loading(); // state 로딩 상태 전환
    await Future.delayed(const Duration(seconds: 3)); // 3초 대기
    final newVideo = VideoModel(title: "${DateTime.now()}"); // 새로운 비디오
    _list = [..._list, newVideo]; // 새로운 비디오 추가

    state = AsyncValue.data(_list); // state 상태 업데이트
  }

  // build메소드에서는 화면이 받을 데이터의 초기화값을 return
  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(const Duration(seconds: 3));

    return _list;
  }
}

/* 
  View로 데이터를 전달하는 Provider 선언
  expose(노출)할 ViewModel(TimeLineView)과
  그 ViewModel에 들어있는 데이터의 형식(List<ViewModel>)을 알려줌
*/
final timelineProvider =
    AsyncNotifierProvider<TimeLineViewModel, List<VideoModel>>(
  () => TimeLineViewModel(),
);
