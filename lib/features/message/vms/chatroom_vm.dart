import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/message/models/chatroom_model.dart';
import 'package:watok/features/message/repos/chatroom_repo.dart';

class ChatRoomViewModel extends AsyncNotifier<void> {
  late ChatRoomRepository _chatRoomRepository;
  @override
  FutureOr<void> build() async {
    _chatRoomRepository = ChatRoomRepository();
  }

  // 채팅룸 생성
  Future<void> createChatRoom({
    required String me,
    required String you,
  }) async {
    await _chatRoomRepository.createChatRoom(me: me, you: you);
  }

  // GETTER 채팅방 정보
  Future<ChatRoomModel> getChatRoom(String chatsId) async {
    final snapshot = await _chatRoomRepository.getChatsInfo(chatsId);
    return ChatRoomModel.fromJSON(json: snapshot.data()!);
  }
}

final chatRoomProvider = AsyncNotifierProvider<ChatRoomViewModel, void>(
  () => ChatRoomViewModel(),
);
