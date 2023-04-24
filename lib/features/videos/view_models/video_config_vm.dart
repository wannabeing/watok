import 'package:flutter/material.dart';
import 'package:watok/features/videos/models/video_config_model.dart';
import 'package:watok/features/videos/repos/video_config_repo.dart';

class VideoConfigViewModel extends ChangeNotifier {
  final VideoConfigRepository _repository; // 디바이스에 저장된 데이터 Repo

  late final VideoConfigModel _model = VideoConfigModel(
    muted: _repository.getMuted(),
    autoplay: _repository.getAutoplay(),
  );

  VideoConfigViewModel(this._repository);

  // getter
  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;

  // setter
  void setMuted(bool value) {
    _repository.setMuted(value); // 디바이스에 새로운 값 저장
    _model.muted = value; // 데이터 값 변경
    notifyListeners(); // listener들에게 변경 알림
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value); // 디바이스에 새로운 값 저장
    _model.autoplay = value; // 데이터 값 변경
    notifyListeners(); // listener들에게 변경 알림
  }
}
