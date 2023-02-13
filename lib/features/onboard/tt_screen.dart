import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watok/features/navigations/main_nav_screen.dart';
import 'package:watok/features/onboard/widgets/tt_first_widget.dart';
import 'package:watok/features/onboard/widgets/tt_second_widget.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

enum DirectScreen { left, right }

enum ShowScreen { first, second }

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  DirectScreen _directScreen = DirectScreen.right; // default
  ShowScreen _showScreen = ShowScreen.first; // default

  // 🚀 손으로 드래그 시작했을 때 실행하는 함수
  void _onDragStart(DragUpdateDetails details) {
    print("start");
    // 왼-오른쪽으로 드래그
    if (details.delta.dx > 0) {
      setState(() {
        _directScreen = DirectScreen.right;
      });
    }
    // 오-왼쪽으로 드래그
    else {
      setState(() {
        _directScreen = DirectScreen.left;
      });
    }
  }

  // 🚀 손으로 드래그 마쳤을 때 실행하는 함수
  void _onDragEnd(DragEndDetails details) {
    // 오-왼쪽 방향 드래그 시
    if (_directScreen == DirectScreen.left) {
      setState(() {
        _showScreen = ShowScreen.second;
      });
    }
    // 왼-오른쪽 방향 드래그 시
    if (_directScreen == DirectScreen.right) {
      setState(() {
        _showScreen = ShowScreen.first;
      });
    }
  }

  void _onStartApp() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavScreen(),
      ),
      (route) => false, // 이전 화면 모두 지우고 이동
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.size24,
            ),
            child: SafeArea(
              child: TabBarView(
                children: [
                  TutorialFirstWidget(),
                  TutorialSecondWidget(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: SizedBox(
                height: Sizes.size96,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TabPageSelector(
                      color: Colors.white,
                      selectedColor: Theme.of(context).primaryColor,
                    ),
                    Gaps.v14,
                    AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      child: CupertinoButton(
                        onPressed: _onStartApp,
                        color: Theme.of(context).primaryColor,
                        child: const Text("이해했어요!"),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
