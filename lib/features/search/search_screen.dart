import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/sizes.dart';

import '../../constants/gaps.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  // 새로고침 함수
  Future<void> _onRefresh() {
    // 원래는 여기에 API 요청을 넣어야함
    return Future.delayed(const Duration(seconds: 2));
  }

  // 검색어 input 상태감지 함수
  void _onSearchChanged(String val) {}

  // 검색어 submit 함수
  void _onSearchSubmitted(String val) {}

  // 키보드 unfocus 함수
  void _onSearchUnfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 1,
          title: CupertinoSearchTextField(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size14,
              horizontal: Sizes.size10,
            ),
            controller: _textEditingController,
            placeholder: "검색어를 입력해주세요.",
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
          ),
          bottom: TabBar(
            onTap: (index) => _onSearchUnfocus(),
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size16,
            ),
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Sizes.size16,
            ),
            tabs: [
              for (var tab in tabs)
                Tab(
                  text: tab,
                ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: _onSearchUnfocus,
          child: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: _onRefresh,
                color: Theme.of(context).primaryColor,
                edgeOffset: 20,
                child: GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(Sizes.size10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Sizes.size20,
                    mainAxisSpacing: Sizes.size20,
                    childAspectRatio: 9 / 20,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Sizes.size8)),
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.cover,
                              placeholder: "assets/images/1.jpeg",
                              image:
                                  "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1180&q=80"),
                        ),
                      ),
                      Gaps.v5,
                      const Text(
                        "testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v5,
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundImage: const NetworkImage(
                                  "https://avatars.githubusercontent.com/u/79440384"),
                            ),
                            Gaps.h5,
                            const Expanded(
                              child: Text(
                                "Anonymous Anonymous Anonymous",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gaps.h5,
                            FaIcon(
                              FontAwesomeIcons.heart,
                              size: Sizes.size20,
                              color: Colors.grey.shade600,
                            ),
                            Gaps.h5,
                            const Text("2.5M"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (var tab in tabs.skip(1))
                Center(
                  child: Text(tab),
                )
            ],
          ),
        ),
      ),
    );
  }
}
