import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/features/message/message_screen.dart';
import 'package:watok/features/mypage/mypage_screen.dart';
import 'package:watok/common/widgets/navigations/widgets/nav_create_video_btn.dart';
import 'package:watok/common/widgets/navigations/widgets/nav_menu.dart';
import 'package:watok/features/search/search_screen.dart';
import 'package:watok/features/videos/video_create_screen.dart';
import 'package:watok/features/videos/video_timeline_screen.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';
import '../darkTheme_config.dart';

class MainNavScreen extends StatefulWidget {
  static const String route = "/home";
  final String tabName; // 이동할 탭명
  const MainNavScreen({
    super.key,
    required this.tabName,
  });

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  final List<String> _tabs = [
    "home",
    "search",
    "test",
    "message",
    "mypage",
  ];
  late int _selectedIndex = _tabs.indexOf(widget.tabName);

  // NAV바 이동 함수
  void _moveNav(int index) {
    context.go("/${_tabs[index]}"); // 해당 탭이름으로 URL 이동
    setState(() {
      _selectedIndex = index;
    });
  }

  // NAV바 비디오 생성 클릭 함수
  void _onCreateVideo() {
    context.push(VideoCreateScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드입력창 생성 시, 자동 높이 조절 X
      backgroundColor: _selectedIndex == 0 || darkThemeConfig.value
          ? Colors.black
          : Colors.white,
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
              child: const SearchScreen(),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: Container(
              alignment: Alignment.center,
              child: const MessageScreen(),
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: Container(
              alignment: Alignment.center,
              child: const MypageScreen(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
          color: _selectedIndex == 0 || darkThemeConfig.value
              ? Colors.black
              : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size24,
            bottom: Sizes.size32,
            left: Sizes.size18,
            right: Sizes.size18,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavMenu(
                iconText: "홈",
                isSelected: _selectedIndex == 0,
                selectedIcon: FontAwesomeIcons.house,
                icon: FontAwesomeIcons.house,
                onTap: () => _moveNav(0),
                selectedIndex: _selectedIndex,
              ),
              NavMenu(
                iconText: "검색",
                isSelected: _selectedIndex == 1,
                selectedIcon: FontAwesomeIcons.solidCompass,
                icon: FontAwesomeIcons.compass,
                onTap: () => _moveNav(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTap: _onCreateVideo,
                child: NavCreateVideoButton(
                  isInverted: _selectedIndex != 0, // 홈이 아닐때만 invert
                ),
              ), // 비디오 생성 버튼
              Gaps.h24,
              NavMenu(
                iconText: "메시지",
                isSelected: _selectedIndex == 3,
                selectedIcon: FontAwesomeIcons.solidMessage,
                icon: FontAwesomeIcons.message,
                onTap: () => _moveNav(3),
                selectedIndex: _selectedIndex,
              ),
              NavMenu(
                iconText: "마이페이지",
                isSelected: _selectedIndex == 4,
                selectedIcon: FontAwesomeIcons.solidUser,
                icon: FontAwesomeIcons.user,
                onTap: () => _moveNav(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
