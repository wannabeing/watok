import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/message/views/dm_detail_screen.dart';
import 'package:watok/features/message/views/dm_select_screen.dart';
import 'package:watok/features/message/vms/chats_list_vm.dart';

class DmScreen extends ConsumerStatefulWidget {
  static const String route = "/dm";

  const DmScreen({super.key});

  @override
  ConsumerState<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends ConsumerState<DmScreen> {
  bool _isAvatar = false;

  // 채팅 추가 함수
  void _addDM() {
    context.pushNamed(DmSelectScreen.name);
  }

  // 채팅 상세보기 이동 함수
  void _detailDM(String chatsId) {
    context.pushNamed(
      DmDetailScreen.name,
      params: {
        "chatsId": chatsId,
      },
    );
  }

  // 아바타 URL이 존재하는지 확인하는 함수
  Future<bool> _existAvatar(String uid) async {
    final request = await HttpClient().getUrl(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/my-watok.appspot.com/o/avatars%2F$uid?alt=media'));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DM"),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _addDM,
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: ref.watch(chatListProvider).when(
            data: (chatList) {
              return ListView.separated(
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final chatInfo = chatList[index];
                  final yourName = chatInfo["yourName"];
                  final yourId = chatInfo["yourId"];

                  // 아바타 URL이 존재하는지 확인
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    _isAvatar = await _existAvatar(yourId);
                    if (mounted) setState(() {});
                  });

                  return Column(
                    children: [
                      ListTile(
                        onTap: () => _detailDM(chatInfo["chatsId"]),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              maxRadius: Sizes.size24,
                              foregroundImage: _isAvatar
                                  ? NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/my-watok.appspot.com/o/avatars%2F$yourId?alt=media")
                                  : null,
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
                                  borderRadius:
                                      BorderRadius.circular(Sizes.size20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          yourName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size18,
                          ),
                        ),
                        subtitle: const Text(
                          "ㅁㅁ?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size16,
                          ),
                        ),
                        trailing: Text(
                          "오전 12:32",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  );
                },
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
    );
  }
}
