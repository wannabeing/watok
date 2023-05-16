import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/mypage/models/user_model.dart';
import 'package:watok/features/mypage/repos/user_repo.dart';

// 나의 대화상대 선택 ViewModel
class MsgSelectViewModel extends AsyncNotifier<List<UserModel>> {
  late UserRepository _userRepository;
  late AuthRepository _authRepository;
  late List<UserModel> _userList;

  @override
  FutureOr<List<UserModel>> build() async {
    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authRepository);

    _userList = await _getFiveUsers();
    state = AsyncValue.data(_userList);
    return _userList;
  }

  // 유저모델 5개 가져오는 함수
  Future<List<UserModel>> _getFiveUsers({String? lastUid}) async {
    final user = _authRepository.user;
    final snapshot = await _userRepository.getFiveUsers(
      lastUid: lastUid,
      loginUid: user!.uid,
    );

    // 각각의 JSON을 UserModel로 변환 후, 변수에 저장
    final users = snapshot.docs.map(
      (doc) => UserModel.fromJSON(doc.data()),
    );

    return users.toList();
  }

  // 더 많은 유저모델 가져오는 함수
  Future<void> getNextUsers() async {
    const AsyncValue.loading();

    final nextUsers = await _getFiveUsers(lastUid: _userList.last.uid);

    state = AsyncValue.data([..._userList, ...nextUsers]);
  }
}

final msgSelectViewModel =
    AsyncNotifierProvider<MsgSelectViewModel, List<UserModel>>(
  () => MsgSelectViewModel(),
);
