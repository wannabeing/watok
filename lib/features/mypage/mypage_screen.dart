import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/mypage/widgets/mypage_userinfo.dart';
import 'package:watok/features/mypage/widgets/persistent_tabbar.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 1.0,
                title: const Text("혁잉"),
                actions: [
                  IconButton(
                    onPressed: (() {}),
                    icon: const FaIcon(FontAwesomeIcons.bell),
                    iconSize: Sizes.size20,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.gear),
                    iconSize: Sizes.size20,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CircleAvatar(
                      maxRadius: Sizes.size52,
                      backgroundColor: Colors.grey.shade500,
                      foregroundImage: const NetworkImage(
                          "https://avatars.githubusercontent.com/u/79440384"),
                    ),
                    Gaps.v14,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "@wannabeing",
                          style: TextStyle(
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Gaps.h3,
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          size: Sizes.size16,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Gaps.v20,
                    SizedBox(
                      height: Sizes.size48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          MyPageUserInfo(text: "팔로우", num: 1),
                          VerticalDivider(
                            width: Sizes.size52,
                            color: Colors.grey,
                            indent: Sizes.size10,
                            endIndent: Sizes.size10,
                          ),
                          MyPageUserInfo(text: "팔로워", num: 3012),
                          VerticalDivider(
                            width: Sizes.size52,
                            color: Colors.grey,
                            indent: Sizes.size10,
                            endIndent: Sizes.size10,
                          ),
                          MyPageUserInfo(text: "좋아요", num: 593),
                        ],
                      ),
                    ),
                    Gaps.v14,
                    FractionallySizedBox(
                      widthFactor: 0.7, // 부모의 너비 70%만큼으로 설정
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: Sizes.size14,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const Text(
                                '팔로우하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Gaps.h10,
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size10,
                                vertical: Sizes.size10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.youtube,
                              ),
                            ),
                          ),
                          Gaps.h10,
                          Flexible(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.size16,
                                vertical: Sizes.size12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.size4),
                                ),
                              ),
                              child: const FaIcon(
                                FontAwesomeIcons.caretDown,
                                size: Sizes.size20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.v20,
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size32,
                      ),
                      child: Text(
                        "소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다소개입니다",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Gaps.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.link,
                          size: Sizes.size16,
                        ),
                        Gaps.h10,
                        Text(
                          "www.naver.com",
                          style: TextStyle(
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v16,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: MyPagePersistentTabBar(),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: Sizes.size3,
                  mainAxisSpacing: Sizes.size3,
                  childAspectRatio: 9 / 12,
                ),
                itemCount: 12,
                itemBuilder: (context, index) => Column(
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 12,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.cover,
                              placeholder: "assets/images/1.jpeg",
                              image:
                                  "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80"),
                        ),
                        Positioned(
                          bottom: Sizes.size3,
                          left: Sizes.size5,
                          child: Row(
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.squareCaretRight,
                                color: Colors.white,
                              ),
                              Gaps.h5,
                              Text(
                                "33",
                                style: TextStyle(
                                  fontSize: Sizes.size16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomDelegate extends SliverPersistentHeaderDelegate {
//   // 사용자가 볼 Widget을 반환
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.indigo,
//       // FractionallySizedBox: 부모로부터 최대한의 공간을 차지하는 Box
//       child: const FractionallySizedBox(
//         heightFactor: 1,
//         child: Center(
//           child: Text("CutomDelegate"),
//         ),
//       ),
//     );
//   }

//   // 최대 높이 getter
//   @override
//   double get maxExtent => 100;
//   // 최소 높이 getter
//   @override
//   double get minExtent => 50;

//   // 위에 build로 사용자에게 보여줄거면 false 반환
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
