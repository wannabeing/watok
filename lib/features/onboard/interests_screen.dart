import 'package:flutter/material.dart';
import 'package:watok/features/onboard/tt_screen.dart';
import 'package:watok/features/onboard/widgets/interest_btn.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import '../../utils.dart';

const interests = [
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
  "Arts & Crafts",
  "Dance",
  "Outdoors",
  "Oddly Satisfying",
  "Home & Garden",
];

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _visibleTitle = false;

  @override
  void initState() {
    super.initState();
    // 스크롤 할 때마다 _onScroll 함수 실행
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 🚀 스크롤 함수
  void _onScroll() {
    if (_visibleTitle) return;
    // 120 이상 스크롤이 되었을 때
    if (_scrollController.offset > 80) {
      setState(() {
        _visibleTitle = true;
      });
    } else {
      setState(() {
        _visibleTitle = false;
      });
    }
  }

  // 🚀 다음 클릭 함수
  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorialScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _visibleTitle ? 1 : 0,
          duration: const Duration(
            milliseconds: 300,
          ),
          child: const Text("관심 분야"),
        ),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.size24,
              right: Sizes.size24,
              bottom: Sizes.size18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v32,
                const Text(
                  "관심분야를 선택해주세요.",
                  style: TextStyle(
                    fontSize: Sizes.size36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Gaps.v20,
                const Opacity(
                  opacity: 0.7,
                  child: Text(
                    "더 나은 비디오를 추천해드리겠습니다.",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                    ),
                  ),
                ),
                Gaps.v64,
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    for (var interest in interests)
                      InterestButton(interest: interest),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkTheme(context)
              ? Colors.grey.shade900
              : Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: Sizes.size48,
            top: Sizes.size32,
            left: Sizes.size24,
            right: Sizes.size24,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size14,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Sizes.size10),
            ),
            child: GestureDetector(
              onTap: _onNext,
              child: const Text(
                "다음",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Sizes.size18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
