import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/utils.dart';
import '../../constants/sizes.dart';

class ActivityScreen extends StatefulWidget {
  static const String route = "/activity";
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  // 회전하는 animation (title 클릭 시, chevron아이콘 animation)
  late final Animation<double> _chevronAnimation = Tween(
    begin: 0.0,
    end: 0.5,
  ).animate(_animationController);

  // 오프셋(비율) animation (title 클릭 시, title 목록 보여주는 animation)
  late final Animation<Offset> _offsetAnimation = Tween(
    begin: const Offset(0, -1), // y축으로 100% 위로 올린 것
    end: Offset.zero,
  ).animate(_animationController);

  // 베리어 animation (title 애니메이션 활성화 시, 뒤쪽 배경 컬러 변경 애니메이션)
  late final Animation<Color?> _barrierAnimation = ColorTween(
    begin: Colors.transparent,
    end: Colors.black38,
  ).animate(_animationController);

  // title 목록
  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "모든 액티비티",
      "icon": FontAwesomeIcons.solidMessage,
    },
    {
      "title": "좋아요",
      "icon": FontAwesomeIcons.solidHeart,
    },
    {
      "title": "댓글",
      "icon": FontAwesomeIcons.solidComments,
    },
    {
      "title": "DM",
      "icon": FontAwesomeIcons.at,
    },
    {
      "title": "팔로워",
      "icon": FontAwesomeIcons.solidUser,
    },
    {
      "title": "TikTok",
      "icon": FontAwesomeIcons.tiktok,
    }
  ];

  // 알람 목록
  final List<String> _alertList = List.generate(20, (index) => "${index}h");

  // Barrier 애니메이션 활성화 여부
  bool _isBarrier = false;

  // 알림창 옆으로 밀어서 없애는 함수
  void _onDismissed(String alertData) {
    _alertList.remove(alertData);
    setState(() {});
  }

  // 제목 카테고리 클릭 애니메이션 함수
  void _onTitleToggleAnimation() async {
    if (_animationController.isCompleted) {
      await _animationController.reverse(); // 거꾸로
    } else {
      _animationController.forward();
    }
    // Barrier 애니메이션 활성화 상태 변경
    setState(() {
      _isBarrier = !_isBarrier;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onTitleToggleAnimation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "모든 액티비티",
              ),
              Gaps.h10,
              RotationTransition(
                turns: _chevronAnimation,
                child: const FaIcon(
                  FontAwesomeIcons.chevronDown,
                  size: Sizes.size14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: Sizes.size20),
            children: [
              for (var alertData in _alertList)
                Dismissible(
                  onDismissed: (direction) => _onDismissed(alertData),
                  key: Key(alertData),
                  child: ListTile(
                    minVerticalPadding: Sizes.size16,
                    leading: Container(
                      width: Sizes.size52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkTheme(context)
                            ? Colors.grey.shade800
                            : Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: Sizes.size2,
                        ),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.bell,
                        ),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        text: "업데이트 내용: ",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme(context)
                              ? Colors.white
                              : Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "삼각별과 세모가 추가되었습니다.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          TextSpan(
                            text: " $alertData",
                            style: TextStyle(
                              fontSize: Sizes.size14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: Sizes.size14,
                    ),
                  ),
                ),
            ],
          ),

          // true일 때만 Barrier애니메이션 활성화
          if (_isBarrier)
            AnimatedModalBarrier(
              color: _barrierAnimation,
              dismissible: true, // onDismiss 함수 실행하기위해 true 설정
              onDismiss: _onTitleToggleAnimation,
            ),

          SlideTransition(
            position: _offsetAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(
                    Sizes.size16,
                  ),
                  bottomRight: Radius.circular(
                    Sizes.size16,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var tab in _tabs)
                    ListTile(
                      title: Row(
                        children: [
                          Icon(
                            tab["icon"],
                            size: Sizes.size16,
                          ),
                          Gaps.h20,
                          Text(
                            tab["title"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
