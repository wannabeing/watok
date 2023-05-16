import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/constants/width_types.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/videos/view_models/video_config_vm.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  // 스위치 테스트 변수
  bool _switchVal = false;

  // 예약 테스트 창 함수
  void _onTestReservation() async {
    final reservation = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: const IconThemeData(),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    print(reservation);
  }

  // 스위치 테스트 함수
  void _onChangedSwitch(bool? newSwitchVal) {
    if (newSwitchVal == null) return;

    setState(() {
      _switchVal = newSwitchVal;
    });
  }

  // 로그아웃 테스트 함수 (IOS)
  void _onTapAlertIOS() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("제목입니다"),
          content: const Text("내용입니다"),
          actions: [
            CupertinoDialogAction(
              child: const Text("넹"),
              onPressed: () => _onLogout(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("아니용"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 함수
  void _onLogout() async {
    // Firebase 로그아웃 요청
    await ref.read(authRepository).sendLogout();

    // 로그인 페이지 redirect
    // if (!mounted) return;
    // context.go(LoginScreen.route);
  }

  // 알림 테스트 함수 (Android)
  void _onTapAlertAndroid() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("제목입니다"),
          content: const Text("내용입니다"),
          actions: [
            TextButton(
              child: const Text("넹"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("아니용"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("설정"),
        elevation: 1,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: WidthTypes.sm),
          child: ListView(
            children: [
              SwitchListTile.adaptive(
                title: const Text("비디오 음소거"),
                subtitle: const Text("서브 타이틀"),
                value: ref.watch(videoConfigProvider).muted,
                onChanged: (value) =>
                    ref.read(videoConfigProvider.notifier).setMuted(value),
              ),
              AnimatedBuilder(
                animation: darkThemeConfig,
                builder: (context, child) {
                  return SwitchListTile.adaptive(
                    title: const Text("다크모드 설정"),
                    subtitle: const Text("서브 타이틀"),
                    value: darkThemeConfig.value,
                    onChanged: (val) =>
                        darkThemeConfig.value = !darkThemeConfig.value,
                  );
                },
              ),
              ListTile(
                title: const Text(
                  "로그아웃 (IOS)",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _onTapAlertIOS,
              ),
              ListTile(
                title: const Text("알림 테스트창 (Android)"),
                onTap: _onTapAlertAndroid,
              ),
              SwitchListTile.adaptive(
                  title: const Text("스위치 테스트"),
                  subtitle: const Text("서브 타이틀"),
                  value: _switchVal,
                  onChanged: _onChangedSwitch),
              ListTile(
                onTap: _onTestReservation,
                title: const Text("날짜예약 테스트 창"),
              ),
              const AboutListTile(
                applicationName: "라이센스 테스트 창",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
