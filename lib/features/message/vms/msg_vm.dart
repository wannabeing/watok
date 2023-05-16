import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/message/models/msg_model.dart';
import 'package:watok/features/message/repos/msg_repo.dart';

class MsgViewModel extends FamilyAsyncNotifier<void, String> {
  late final MsgRepository _msgRepository;
  static late String _chatsId;

  @override
  FutureOr<void> build(String arg) {
    _msgRepository = ref.read(msgRepository);
    _chatsId = arg;
  }

  // 메시지 보내기 함수
  Future<void> sendMsg(String text) async {
    final user = ref.read(authRepository).user;
    state = await AsyncValue.guard(
      () async {
        final newMsgModel = MsgModel(
          uid: user!.uid,
          text: text,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await _msgRepository.sendMsg(
          chatsId: _chatsId,
          msgModel: newMsgModel,
        );
      },
    );
  }

  Future<String> getChatsId() async {
    return _chatsId;
  }
}

final msgProvider = AsyncNotifierProvider.family<MsgViewModel, void, String>(
  () => MsgViewModel(),
);

// stream Provider
final msgStreamProvider =
    StreamProvider.family.autoDispose<List<MsgModel>, String>((ref, _chatsId) {
  final db = FirebaseFirestore.instance;

  final snapshots = db
      .collection("chats")
      .doc(_chatsId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots();

  final chatList = snapshots.map(
    (snapshot) => snapshot.docs
        .map(
          (doc) => MsgModel.fromJSON(
            json: doc.data(),
          ),
        )
        .toList(),
  );
  return chatList;
});
