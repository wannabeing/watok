import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/authentication/view_models/auth_view_model.dart';
import 'package:watok/features/mypage/models/user_model.dart';
import 'package:watok/features/mypage/repos/user_repo.dart';

class UserViewModel extends AsyncNotifier<UserModel> {
  late UserRepository _userRepository;
  late AuthRepository _authRepository;
  late Map<dynamic, dynamic> form;

  // 초기화 및 데이터 세팅
  @override
  FutureOr<UserModel> build() async {
    // 레포지토리 초기화
    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authRepository);
    // 회원가입 폼 데이터 초기화
    form = ref.read(authForm);

    // 로그인되어있으면
    if (_authRepository.isLogin) {
      final fromDB =
          await _userRepository.getProfile(_authRepository.user!.uid);

      if (fromDB != null) {
        return UserModel.fromJSON(fromDB); // 유저 정보 return
      }
    }
    return UserModel.empty(); // 유저 빈 생성자 return
  }

  // 유저 생성 함수 호출
  Future<void> createAccount(UserCredential createUser) async {
    // Error 처리
    if (createUser.user == null) {
      throw Exception("유저생성이 되지 않았습니다.");
    }
    // SET 로딩중
    state = const AsyncValue.loading();
    // 새로운 유저 프로필
    final newProfile = UserModel(
      uid: createUser.user!.uid,
      email: createUser.user!.email ?? "test@test.com",
      name: createUser.user!.displayName ?? "익명",
      bio: "undefined",
      link: "undefined",
      birthday: form["birthday"],
      avatarUrl: false,
    );
    // firestore 함수 호출
    await _userRepository.createProfile(newProfile);
    // UPDATE 유저뷰모델 state에 저장
    state = AsyncValue.data(newProfile);
  }

  // 아바타이미지 업로드 state 변경함수
  Future<void> updateAvatar() async {
    // UPDATAE state
    state = AsyncValue.data(state.value!.coverModel(avatarUrl: true));

    // UPDATE DB
    await _userRepository.updateProfile(
      state.value!.uid,
      {"avatarUrl": true},
    );
  }

  // 유저 프로필 업데이트 state 변경함수
  Future<void> updateProfile(
      String newName, String newBio, String newLink) async {
    // UPDATAE state
    state = AsyncValue.data(
        state.value!.coverModel(name: newName, bio: newBio, link: newLink));

    // UPDATE DB
    await _userRepository.updateProfile(
      state.value!.uid,
      {"name": newName, "bio": newBio, "link": newLink},
    );
  }
}

/* 
  View에서 사용할 수 있는 Provider
  expose(노출)할 ViewModel과
  그 ViewModel에 들어있는 데이터의 형식을 알려줌
*/
final userProvider = AsyncNotifierProvider<UserViewModel, UserModel>(
  () => UserViewModel(),
);
