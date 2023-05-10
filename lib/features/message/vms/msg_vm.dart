import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/message/models/msg_model.dart';
import 'package:watok/features/message/repos/msg_repo.dart';

class MsgViewModel extends AsyncNotifier<void> {
  late final MsgRepository _msgRepository;

  @override
  FutureOr<void> build() {
    _msgRepository = ref.read(msgRepository);
  }

  Future<void> sendMsg(String text) async {
    final user = ref.read(authRepository).user;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final newMsgModel = MsgModel(
          uid: user!.uid,
          text: text,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await _msgRepository.sendMsg(newMsgModel);
      },
    );
  }
}

final msgViewModel = AsyncNotifierProvider<MsgViewModel, void>(
  () => MsgViewModel(),
);

final msgStremViewModel = StreamProvider.autoDispose<List<MsgModel>>((ref) {
  final db = FirebaseFirestore.instance;

  final snapshots = db
      .collection("chats")
      .doc("0sTJpZnOfxc30joVJyvz")
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
