import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/router.dart';

import 'constants/sizes.dart';

void main() async {
  // 디바이스 세로방향 고정
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = darkThemeConfig.value;

  @override
  void initState() {
    super.initState();
    darkThemeConfig.addListener(() {
      setState(() {
        _isDark = darkThemeConfig.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
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
