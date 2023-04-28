// data를 디바이스에 저장/읽기 클래스

import 'package:shared_preferences/shared_preferences.dart';

class VideoConfigRepository {
  static const String _muted = "muted";

  final SharedPreferences _preferences;
  VideoConfigRepository(this._preferences);

  // 기기 setter
  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  // 기기 getter
  bool getMuted() {
    return _preferences.getBool(_muted) ??
        false; // 디바이스에 값이 null이면 false return
  }
}
