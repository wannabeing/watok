import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/onboard/interests_screen.dart';

class AuthRepository {
  // Firebase 연결
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Firebase 유저체크 관련 함수
  User? get user => _firebaseAuth.currentUser;
  bool get isLogin => user != null;
  Stream<User?> listenStream() =>
      _firebaseAuth.authStateChanges(); // 유저 로그인 여부 확인

  // 이메일계정 중복확인 함수
  FutureOr<bool> emailCheck(String email) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: "password");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  // Firebase 유저생성 함수
  Future<UserCredential> sendCreateUser(String email, String pw) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: pw,
    );
  }

  // Firebase 유저로그아웃 함수
  Future<void> sendLogout() async {
    await _firebaseAuth.signOut();
  }

  // Firebase 유저로그인 함수
  Future<void> sendLogin(LoginArgs args) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: args.email,
      password: args.pw,
    );
  }

  // Github 유저로그인 함수
  Future<void> sendGithubLogin() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

final authRepository = Provider((ref) => AuthRepository());

// 외부에서도 사용하기위한 StreamProvider
final authStream = StreamProvider((ref) {
  final repo = ref.read(authRepository);
  return repo.listenStream();
});
