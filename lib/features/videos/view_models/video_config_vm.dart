import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/videos/models/video_config_model.dart';
import 'package:watok/features/videos/repos/video_config_repo.dart';

class VideoConfigViewModel extends Notifier<VideoConfigModel> {
  final VideoConfigRepository _repository; // 디바이스에 저장된 데이터 Repo

  VideoConfigViewModel(this._repository);

  // setter
  void setMuted(bool value) {
    _repository.setMuted(value); // 디바이스에 새로운 값 저장
    state = VideoConfigModel(muted: value); // 새로운 state 생성 및 저장
  }

  /* 
  build메소드는 STATE를 초기화하여 반환
  Notifier안에서는 state로 데이터에 접근할 수 있음 -> setMuted()
  */
  @override
  VideoConfigModel build() {
    return VideoConfigModel(
      muted: _repository.getMuted(),
    );
  }
}

final videoConfigProvider =
    NotifierProvider<VideoConfigViewModel, VideoConfigModel>(
  () => throw UnimplementedError,
);

// VideoConfigViewModel의 데이터 변화를 expose(노출)시킬건데, 그 형태는 VideoConfigModel이다.
