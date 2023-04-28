import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/common/widgets/navigations/main_nav_screen.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/onboard/interests_screen.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late AuthRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepository);
  }

  // 로그인 요청 함수
  Future<void> userLogin(LoginArgs args, BuildContext context) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _authRepository.sendLogin(args),
    );

    if (state.hasError) {
      final snack = SnackBar(
        content: Text(
          (state.error as FirebaseException).message ?? "먼가 잘못댐;",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    } else {
      if (!context.mounted) return;
      context.go(MainNavScreen.route);
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
