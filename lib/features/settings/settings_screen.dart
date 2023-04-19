import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/constants/width_types.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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

  // 알림 테스트 함수 (IOS)
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
              onPressed: () => Navigator.of(context).pop(),
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
                title: const Text("알림 테스트창 (IOS)"),
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
