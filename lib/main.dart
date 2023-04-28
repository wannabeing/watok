import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/features/videos/repos/video_config_repo.dart';
import 'package:watok/features/videos/view_models/video_config_vm.dart';
import 'package:watok/firebase_options.dart';
import 'package:watok/router.dart';

import 'constants/sizes.dart';

void main() async {
  // 디바이스 세로방향 고정
  WidgetsFlutterBinding.ensureInitialized();

  // firebase 설정 (IOS/ANDROID/WEB)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // SharedPreference 정의
  final preferences = await SharedPreferences.getInstance();
  final repo = VideoConfigRepository(preferences);

  /*
    - ProviderScope: overrides
      앱이 시작되기 직전에 SharedPreferences가 완료되면 ProviderScope에게 
      VideoConfigViewModel에게 repo를 전달하고 재정의시킨다.
  */
  runApp(
    ProviderScope(
      overrides: [
        videoConfigProvider.overrideWith(
          () => VideoConfigViewModel(repo),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    darkThemeConfig.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: '와톡',
      // themeMode: ThemeMode.system,
      themeMode: darkThemeConfig.value ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
          surfaceTintColor: Colors.white,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFFE9435A),
          indicatorColor: Color(0xFFE9435A),
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size16,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.black,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade100,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        brightness: Brightness.dark,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
          surfaceTintColor: Colors.grey.shade900,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color(0xFFE9435A),
          indicatorColor: Color(0xFFE9435A),
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size16,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Colors.white,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
        ),
      ),
    );
  }
}
