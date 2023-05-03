import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';

import '../../../common/widgets/navigations/main_nav_screen.dart';

class GithubViewModel extends AsyncNotifier<void> {
  late AuthRepository _authRepository;

  // 초기화 및 데이터 세팅
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepository);
  }

  // github 로그인 함수
  Future<void> signIn(BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _authRepository.sendGithubLogin();
    });

    if (state.hasError) {
      final snack = SnackBar(
        content: Text(
          (state.error as FirebaseException).message ?? "먼가 잘못댐;",
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snack);
    } else {
      context.go(MainNavScreen.route);
    }
  }
}

/* 
  View에서 사용할 수 있는 Provider
  expose(노출)할 ViewModel과
  그 ViewModel에 들어있는 데이터의 형식을 알려줌
*/
final githubProvider = AsyncNotifierProvider<GithubViewModel, void>(
  () => GithubViewModel(),
);
