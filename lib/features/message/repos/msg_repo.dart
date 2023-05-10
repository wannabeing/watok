import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/message/models/msg_model.dart';

class MsgRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 메시지 전송
  // chats/:chatId/texts/{ ...msgModel }
  Future<void> sendMsg(MsgModel msgModel) async {
    await _db
        .collection("chats")
        .doc("0sTJpZnOfxc30joVJyvz")
        .collection("texts")
        .add(msgModel.toJSON());
  }
}

final msgRepository = Provider((ref) => MsgRepository());
