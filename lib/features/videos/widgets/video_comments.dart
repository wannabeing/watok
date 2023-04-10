import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/constants/width_types.dart';
import 'package:watok/utils.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false; // 입력창 활성화 여부
  final ScrollController _scrollController = ScrollController();

  // 댓글창 Body 클릭 함수
  void _onCommentsBodyClick() {
    // 댓글 입력 중에 Body클릭시, 입력창 포커스 해제
    FocusScope.of(context).unfocus();
    // 입력창 상태 비활성화
    setState(() {
      _isWriting = false;
    });
  }

  // 입력창 클릭 함수
  void _onCommentsInputClick() {
    // 입력창 상태 활성화
    setState(() {
      _isWriting = true;
    });
  }

  // 새로고침 함수
  Future<void> _onRefresh() {
    // 원래는 여기에 API 요청을 넣어야함
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    // 휴대폰 너비
    final userDeviceSize = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor,
      edgeOffset: 20,
      child: GestureDetector(
        onTap: _onCommentsBodyClick,
        child: Container(
          height: userDeviceSize.height * 0.8,
          clipBehavior: Clip.hardEdge,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(Sizes.size16)),
          child: Scaffold(
            backgroundColor: isDarkTheme(context) ? null : Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor:
                  isDarkTheme(context) ? null : Colors.grey.shade50,
              title: const Text("23 comments"),
              actions: const [
                CloseButton(),
              ],
            ),
            body: Stack(
              children: [
                // 📕 댓글 아이콘,텍스트,하트아이콘
                Scrollbar(
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      top: Sizes.size10,
                      bottom: Sizes.size96 + Sizes.size10,
                      left: Sizes.size16,
                      right: Sizes.size16,
                    ),
                    separatorBuilder: (context, index) => Gaps.v20,
                    itemCount: 10,
                    itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: isDarkTheme(context)
                              ? Colors.grey.shade800
                              : null,
                          child: const Text("A"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Anonymous",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Sizes.size14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Gaps.v4,
                              const Text(
                                  "댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다댓글입니다."),
                            ],
                          ),
                        ),
                        Gaps.h5,
                        Column(
                          children: [
                            Gaps.v20,
                            FaIcon(FontAwesomeIcons.heart,
                                color: Colors.grey.shade500),
                            Gaps.v4,
                            Text(
                              "42",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 📕 댓글 입력창
                Positioned(
                  bottom: 0,
                  width: kIsWeb ? WidthTypes.sm : userDeviceSize.width,
                  child: BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size16,
                        vertical: Sizes.size10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: isDarkTheme(context)
                                ? Colors.grey.shade800
                                : null,
                            child: const Text("A"),
                          ),
                          Gaps.h10,
                          // 📕 input
                          Expanded(
                            child: SizedBox(
                              height: Sizes.size48,
                              child: TextField(
                                onTap: _onCommentsInputClick,
                                expands: true,
                                maxLines: null,
                                minLines: null,
                                textInputAction: TextInputAction.newline,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      right: Sizes.size14,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.at,
                                          color: isDarkTheme(context)
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h10,
                                        FaIcon(
                                          FontAwesomeIcons.gift,
                                          color: isDarkTheme(context)
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h10,
                                        FaIcon(
                                          FontAwesomeIcons.faceSmile,
                                          color: isDarkTheme(context)
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade900,
                                        ),
                                        Gaps.h10,
                                        if (_isWriting)
                                          GestureDetector(
                                            onTap: _onCommentsBodyClick,
                                            child: FaIcon(
                                              FontAwesomeIcons.circleArrowUp,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  hintText: "댓글을 입력해주세요",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizes.size12),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: isDarkTheme(context)
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.size12,
                                    vertical: Sizes.size10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
