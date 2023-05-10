import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/message/vms/msg_vm.dart';

class DmDetailScreen extends ConsumerStatefulWidget {
  static const name = "dmDetail";
  static const route = ":chatId";
  final String chatId;

  const DmDetailScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<DmDetailScreen> createState() => _DmDetailScreenState();
}

class _DmDetailScreenState extends ConsumerState<DmDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isWriting = false; // 입력창 활성화 여부
  String _text = '';

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

  void _onSubmit() async {
    if (_text == '') return;

    await ref.read(msgViewModel.notifier).sendMsg(_text);

    // 텍스트필드 초기화
    _textController.text = '';
    setState(() {
      _text = '';
    });
  }

  // 스크롤 끝까지 했을 경우
  void _onMaxScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _text = _textController.text;
      });
    });

    _scrollController.addListener(() {
      _onMaxScroll();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String chatId = widget.chatId;

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
            "혁잉 ($chatId)",
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
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
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
            ref.watch(msgStremViewModel).when(
                  data: (msgList) {
                    final user = ref.read(authRepository).user;
                    // 리스트뷰 끝으로 이동
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    });

                    return ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        top: Sizes.size24,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size20,
                        right: Sizes.size20,
                      ),
                      itemBuilder: (context, index) {
                        final msg = msgList[index]; // 각 메시지
                        final isMyMsg = msg.uid == user!.uid; // 나의 메시지 체크

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMyMsg
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(Sizes.size10),
                              decoration: BoxDecoration(
                                  color: isMyMsg ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        const Radius.circular(Sizes.size16),
                                    topRight:
                                        const Radius.circular(Sizes.size16),
                                    bottomLeft: isMyMsg
                                        ? const Radius.circular(Sizes.size16)
                                        : const Radius.circular(Sizes.size5),
                                    bottomRight: !isMyMsg
                                        ? const Radius.circular(Sizes.size16)
                                        : const Radius.circular(Sizes.size5),
                                  )),
                              child: Text(
                                msg.text,
                                style: const TextStyle(
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
                      itemCount: msgList.length,
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      "$error",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: darkThemeConfig.value
                    ? Colors.grey.shade900
                    : Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.size16,
                    vertical: Sizes.size36,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: Sizes.size52,
                          child: TextField(
                            controller: _textController,
                            onTap: _onTapInput,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            autocorrect: false,
                            onEditingComplete: _onSubmit, // 키보드 입력창에서 submit
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
                                      color: darkThemeConfig.value
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade900,
                                    ),
                                    Gaps.h10,
                                    if (_isWriting)
                                      GestureDetector(
                                        onTap: _onSubmit,
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
                              fillColor: darkThemeConfig.value
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
