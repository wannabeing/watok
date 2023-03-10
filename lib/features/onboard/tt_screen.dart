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

  // π μμΌλ‘ λλκ·Έ μμνμ λ μ€ννλ ν¨μ
  void _onDragStart(DragUpdateDetails details) {
    print("start");
    // μΌ-μ€λ₯Έμͺ½μΌλ‘ λλκ·Έ
    if (details.delta.dx > 0) {
      setState(() {
        _directScreen = DirectScreen.right;
      });
    }
    // μ€-μΌμͺ½μΌλ‘ λλκ·Έ
    else {
      setState(() {
        _directScreen = DirectScreen.left;
      });
    }
  }

  // π μμΌλ‘ λλκ·Έ λ§μ³€μ λ μ€ννλ ν¨μ
  void _onDragEnd(DragEndDetails details) {
    // μ€-μΌμͺ½ λ°©ν₯ λλκ·Έ μ
    if (_directScreen == DirectScreen.left) {
      setState(() {
        _showScreen = ShowScreen.second;
      });
    }
    // μΌ-μ€λ₯Έμͺ½ λ°©ν₯ λλκ·Έ μ
    if (_directScreen == DirectScreen.right) {
      setState(() {
        _showScreen = ShowScreen.first;
      });
    }
  }

  // π μ± μμνκΈ° ν¨μ
  void _onStartApp() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavScreen(),
      ),
      (route) => false, // μ΄μ  νλ©΄ λͺ¨λ μ§μ°κ³  μ΄λ
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
                        child: const Text("μ΄ν΄νμ΄μ!"),
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
