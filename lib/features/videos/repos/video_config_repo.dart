// data를 디바이스에 저장/읽기 클래스

import 'package:shared_preferences/shared_preferences.dart';

class VideoConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;
  VideoConfigRepository(this._preferences);

  // setter
  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  // getter
  bool getMuted() {
    return _preferences.getBool(_muted) ?? false; // 디바이스에 값이 없다면 false return
  }

  bool getAutoplay() {
    return _preferences.getBool(_autoplay) ??
        false; // 디바이스에 값이 없다면 false return
  }
}
