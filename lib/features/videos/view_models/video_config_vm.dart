import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/videos/models/video_config_model.dart';
import 'package:watok/features/videos/repos/video_config_repo.dart';

class VideoConfigViewModel extends Notifier<VideoConfigModel> {
  final VideoConfigRepository _repository; // 디바이스에 저장된 데이터

  VideoConfigViewModel(this._repository);

  // state 변경 함수
  void setMuted(bool value) {
    _repository.setMuted(value); // 디바이스에 새로운 값 저장
    state = VideoConfigModel(
      muted: value,
    ); // state 재생성 및 저장
  }

  /* 
    build메소드는 STATE를 초기화하여 반환
    Notifier안에서는 state로 데이터에 접근할 수 있음 -> setMuted()
  */
  @override
  VideoConfigModel build() {
    return VideoConfigModel(
      muted: _repository.getMuted(), // 초기 데이터 불러오기
    );
  }
}

/* 
  Provider는 데이터를 얻기위해서, 메소드를 실행하기 위해서 사용한다.
  
  Provider는 두개의 타입을 갖는다.
    1. VideoConfigViewModel의 데이터 변화를 expose(노출)시킬건데, 
    2. 그 형태는 VideoConfigModel이다.

  SharedPreference를 사용한 repository가 필요한데, main에서 await하므로 구현이 안된 상태일 수 있다.
  따라서 해당 에러를 throw한다.
    - UnimplementedError
    아직 구현되지 않은 작업에 의해 throw됩니다.
    이 [오류]는 필요한 모든 기능을 아직 구현하지 않은 미완성 코드에 의해 발생합니다.
*/
final videoConfigProvider =
    NotifierProvider<VideoConfigViewModel, VideoConfigModel>(
  () => throw UnimplementedError,
);
