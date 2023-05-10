import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/message/views/dm_detail_screen.dart';

class DmSelectScreen extends ConsumerStatefulWidget {
  const DmSelectScreen({super.key});
  static const String route = "dmSelect";
  static const String name = "dmSelect";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DmSelectScreenState();
}

class _DmSelectScreenState extends ConsumerState<DmSelectScreen> {
  void _onDetail() {
    context.pushNamed(
      DmDetailScreen.name,
      params: {
        "chatId": "1",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("대화상대 선택"),
        elevation: 1,
        actions: [
          GestureDetector(
            onTap: _onDetail,
            child: Padding(
              padding: const EdgeInsets.only(right: Sizes.size18),
              child: Text(
                "확인",
                style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          )
        ],
      ),
      body: const Text("hi"),
    );
  }
}
