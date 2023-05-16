import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/message/repos/chatroom_repo.dart';

class ChatsListViewModel extends AsyncNotifier<List<Map<String, dynamic>>> {
  late List<Map<String, dynamic>> _chatsList; // Chats 리스트
  late ChatRoomRepository _chatRoomRepository;
  late String uid;

  // 체팅방 초기화
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    _chatRoomRepository = ref.read(chatroomRepository);
    uid = ref.read(authRepository).user!.uid;

    _chatsList = await _getChats(uid: uid);
    state = AsyncValue.data(_chatsList);
    return _chatsList;
  }

  // 채팅방 5개 가져오는 함수
  Future<List<Map<String, dynamic>>> _getChats({required String uid}) async {
    final snapshot = await _chatRoomRepository.getChatsList(uid: uid);

    // 각각의 JSON을 ChatRoomModel로 변환 후, 변수에 저장
    final chatsList = snapshot.docs.map(
      (doc) => doc.data(),
    );
    // final chatsList = snapshot.docs.map(
    //   (doc) => ChatRoomModel.fromJSON(
    //     json: doc.data(),
    //   ),
    // );

    return chatsList.toList();
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatsListViewModel, List<Map<String, dynamic>>>(
  () => ChatsListViewModel(),
);
