import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 채팅방 생성
  Future<void> createChatRoom({
    required String me,
    required String you,
  }) async {
    await _db.collection("chats").add({
      "me": me,
      "you": you,
    });
  }

  // 나의 모든 채팅방 조회
  Future<QuerySnapshot<Map<String, dynamic>>> getChatsList(
      {required String uid}) async {
    final query =
        _db.collection("users").doc(uid).collection("mychats").limit(5);

    final result = await query.get();

    return result;
  }

  // 채팅방 정보 조회
  Future<DocumentSnapshot<Map<String, dynamic>>> getChatsInfo(
      String chatsId) async {
    return await _db.collection("chats").doc(chatsId).get();
  }
}

final chatroomRepository = Provider((ref) => ChatRoomRepository());
