import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';

import '../../constants/sizes.dart';

class DmDetailScreen extends StatefulWidget {
  const DmDetailScreen({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<DmDetailScreen> createState() => _DmDetailScreenState();
}

class _DmDetailScreenState extends State<DmDetailScreen> {
  bool _isWriting = false; // 입력창 활성화 여부

  // 인풋창 클릭 함수
  void _onTapInput() {
    setState(() {
      _isWriting = true;
    });
  }

  // 인풋창 이외의 곳 클릭 함수
  void _onTapBody() {
    // 인풋창 이외의 곳 클릭시, 인풋창 포커스 해제
    FocusScope.of(context).unfocus();
    // 인풋창 상태 비활성화
    setState(() {
      _isWriting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = widget.index; // 상속 받은 index 값

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            children: [
              CircleAvatar(
                maxRadius: Sizes.size24,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundImage: const NetworkImage(
                    "https://avatars.githubusercontent.com/u/79440384"),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                    borderRadius: BorderRadius.circular(Sizes.size20),
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            "혁잉 ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Sizes.size18,
            ),
          ),
          subtitle: const Text("활동 중"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _onTapBody,
        child: Stack(
          children: [
            ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size24,
                horizontal: Sizes.size20,
              ),
              itemBuilder: (context, index) {
                final isMyMsg = index % 2 == 0;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      isMyMsg ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Sizes.size10),
                      decoration: BoxDecoration(
                          color: isMyMsg ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(Sizes.size16),
                            topRight: const Radius.circular(Sizes.size16),
                            bottomLeft: isMyMsg
                                ? const Radius.circular(Sizes.size16)
                                : const Radius.circular(Sizes.size5),
                            bottomRight: !isMyMsg
                                ? const Radius.circular(Sizes.size16)
                                : const Radius.circular(Sizes.size5),
                          )),
                      child: const Text(
                        "자니?",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: Sizes.size18,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Gaps.v10,
              itemCount: 4,
            ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size40,
                          child: TextField(
                            onTap: _onTapInput,
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
                                      FontAwesomeIcons.faceSmile,
                                      color: Colors.grey.shade900,
                                    ),
                                    Gaps.h10,
                                    if (_isWriting)
                                      GestureDetector(
                                        onTap: _onTapBody,
                                        child: FaIcon(
                                          FontAwesomeIcons.circleArrowUp,
                                          color: Theme.of(context).primaryColor,
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
                              fillColor: Colors.grey.shade200,
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
                // child: Row(
                //   children: [
                //     const Expanded(child: TextField()),
                //     Gaps.h20,
                //     Container(
                //       child: const FaIcon(FontAwesomeIcons.paperPlane),
                //     )
                //   ],
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
