import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/mypage/view_models/user_view_model.dart';

/* 
  해당 뷰 모델에서는 값을 expose(노출)하지 않고
  Firebase에게 요청 역할만 한다.
  때문에 void 추가 
*/
class AuthViewModel extends AsyncNotifier<bool?> {
  // Firebase와 연결되어있는 Repo 생성
  late final AuthRepository _authRepository;

  // Repo 초기화
  @override
  FutureOr<bool> build() {
    _authRepository = ref.read(authRepository);
    return true;
  }

  // 이메일 중복 확인 함수
  FutureOr<bool> isValidEmail() async {
    final form = ref.read(authForm); // 사용자가 입력한 id/pw가 저장된 Provider
    state = const AsyncValue.loading(); // SET 로딩

    final check = await _authRepository.emailCheck(form["email"]); // 이메일 체크
    state = AsyncValue.data(check); // SET OFF 로딩
    return check; // 이메일 중복여부 return
  }

  // 계정생성 함수
  Future<void> createUser() async {
    // 사용자가 입력한 id/pw가 저장된 Provider
    final form = ref.read(authForm);

    // loading 상태 전환
    state = const AsyncValue.loading();

    // 새로운 사용자 정보를 DB에 담을 Provider
    final newUserProvider = ref.read(userProvider.notifier);

    /* 
      계정생성 함수 호출 
      - AsyncValue.guard()
        통신에 성공하면 state에 데이터를 return하고,
        실패하면 error메시지를 return한다.
    */
    state = await AsyncValue.guard(
      () async {
        final userCredential = await _authRepository.sendCreateUser(
          form["email"],
          form["pw"],
        );

        // 유저가 생성되었다면 유저정보 저장 provider 호출
        await newUserProvider.createAccount(userCredential);
        return null;
      },
    );
    // Error 처리
    if (state.hasError) {}
  }
}

// StateProvider는 외부에서 수정할 수 있는 값을 expose(노출)하는 Provider.
final authForm = StateProvider((ref) => {});

/* 
  View에서 사용할 수 있는 Provider
  expose(노출)할 ViewModel과
  그 ViewModel에 들어있는 데이터의 형식을 알려줌
*/
final authProvider = AsyncNotifierProvider<AuthViewModel, bool?>(
  () => AuthViewModel(),
);
