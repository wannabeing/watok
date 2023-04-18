import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/features/message/dm_detail_screen.dart';

import '../../constants/sizes.dart';

class DmScreen extends StatefulWidget {
  static const String route = "/dm";

  const DmScreen({super.key});

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  final List<int> _chatsList = [];
  final Duration _duration = const Duration(milliseconds: 300);

  // 채팅 위젯 생성 함수
  Widget _createListTile(int index) {
    return ListTile(
      onLongPress: () => _delDM(index),
      onTap: () => _detailDM(index),
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
      subtitle: const Text(
        "자니?",
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
    );
  }

  // 채팅 추가 함수
  void _addDM() {
    if (_key.currentState != null) {
      _key.currentState!.insertItem(
        _chatsList.length,
        duration: _duration,
      );
      _chatsList.add(_chatsList.length);
    }
  }

  // 채팅 삭제 함수
  void _delDM(int index) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _createListTile(index),
        ),
        duration: _duration,
      );
      _chatsList.removeAt(index);
    }
  }

  // 채팅 상세보기 이동 함수
  void _detailDM(int index) {
    context.pushNamed(
      DmDetailScreen.name,
      params: {
        "chatId": "wannabeing$index",
      },
    );
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
      body: AnimatedList(
        key: _key,
        padding: const EdgeInsets.symmetric(vertical: Sizes.size20),
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            key: UniqueKey(),
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              child: _createListTile(index),
            ),
          );
        },
      ),
    );
  }
}
