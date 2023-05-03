import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/mypage/repos/user_repo.dart';
import 'package:watok/features/mypage/view_models/user_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late UserRepository _userRepository;

  // 초기화
  @override
  FutureOr<void> build() {
    _userRepository = ref.read(userRepository);
  }

  // 업로드 호출 함수
  Future<void> upload(File file) async {
    state = const AsyncValue.loading(); // SET Loading
    final uid = ref.read(authRepository).user!.uid; // 유저ID

    state = await AsyncValue.guard(
      () async {
        // DB 업로드 함수 호출
        await _userRepository.uploadAvatarImg(file, uid);

        // DB 아바타 이미지 업데이트 함수 호출
        await ref.read(userProvider.notifier).updateAvatar();
      },
    );
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
