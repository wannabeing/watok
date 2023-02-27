import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:watok/features/navigations/widgets/nav_create_video_btn.dart';
import 'package:watok/features/navigations/widgets/nav_menu.dart';
import 'package:watok/features/videos/video_timeline_screen.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  // NAV바 이동 함수
  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // NAV바 비디오 생성 클릭 함수
  void _onCreateVideo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Scaffold(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드입력창 생성 시, 자동 높이 조절 X
      backgroundColor: _selectedIndex == 0 ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            // offstage: false이면 화면에 보임
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: Container(
              alignment: Alignment.center,
              child: const ReadMoreText(
                "items title",
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Length,
                trimLength: 5,
                trimCollapsedText: '..더보기',
                style: TextStyle(fontSize: 13),
                trimExpandedText: ' Less',
              ),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: Container(
              alignment: Alignment.center,
              child: const Text("test"),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: Container(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavMenu(
                iconText: "홈",
                isSelected: _selectedIndex == 0,
                selectedIcon: FontAwesomeIcons.house,
                icon: FontAwesomeIcons.house,
                onTap: () => _onTap(0),
              ),
              NavMenu(
                iconText: "검색",
                isSelected: _selectedIndex == 1,
                selectedIcon: FontAwesomeIcons.solidCompass,
                icon: FontAwesomeIcons.compass,
                onTap: () => _onTap(1),
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onCreateVideo,
                child: const NavCreateVideoButton(),
              ), // 비디오 생성 버튼
              Gaps.h24,
              NavMenu(
                iconText: "메시지",
                isSelected: _selectedIndex == 3,
                selectedIcon: FontAwesomeIcons.solidMessage,
                icon: FontAwesomeIcons.message,
                onTap: () => _onTap(3),
              ),
              NavMenu(
                iconText: "마이페이지",
                isSelected: _selectedIndex == 4,
                selectedIcon: FontAwesomeIcons.solidUser,
                icon: FontAwesomeIcons.user,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
