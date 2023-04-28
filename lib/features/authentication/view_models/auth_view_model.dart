import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';

/* 
  해당 뷰 모델에서는 값을 expose(노출)하지 않고
  Firebase에게 요청 역할만 한다.
  때문에 void 추가 
*/
class AuthViewModel extends AsyncNotifier<void> {
  // Firebase와 연결되어있는 Repo 생성
  late final AuthRepository _authRepository;

  // Repo 초기화
  @override
  FutureOr<void> build() {
    _authRepository = ref.read(authRepository);
  }

  // 계정생성 함수
  Future<void> createUser() async {
    // loading 상태 전환
    state = const AsyncValue.loading();

    // 사용자가 입력한 id/pw가 저장된 Provider
    final form = ref.read(authForm);
    /* 
      계정생성 함수 호출 
      
      - AsyncValue.guard()
        통신에 성공하면 state에 데이터를 return하고,
        실패하면 error메시지를 return한다.
    */
    state = await AsyncValue.guard(() async {
      return await _authRepository.sendCreateUser(
        form["email"],
        form["pw"],
      );
    });
  }
}

// StateProvider는 외부에서 수정할 수 있는 값을 expose(노출)하는 Provider.
final authForm = StateProvider((ref) => {});

// View에서 사용할 수 있는 Provider
final authProvider = AsyncNotifierProvider<AuthViewModel, void>(
  () => AuthViewModel(),
);
