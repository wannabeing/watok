import 'package:flutter/material.dart';

// 디바이스가 다크모드인지 확인하는 함수
bool isDarkTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}
