import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';
import 'package:watok/features/onboard/interests_screen.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class LoginFormScreen extends StatefulWidget {
  static String route = "/loginForm";
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 폼 데이터 변수
  Map<String, String> formData = {};

  // 🚀 로그인 함수
  void _onSubmit() {
    bool? isVal = _formKey.currentState?.validate(); // 폼 데이터유효성 검사

    if (isVal == true) {
      _formKey.currentState?.save();

      // goRouter에서 파라미터 보내면서 페이지 이동
      context.go(
        InterestsScreen.route,
        extra: FormArgs(
          username: formData["email"]!,
          pw: formData["pw"]!,
        ),
      );

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //   arguments: FormArgs(
      //     form: formData,
      //   ), // formData 변수 전달
      //   InterestsScreen.route,
      //   (route) => false,
      // route에는 이전 화면들의 정보가 담겨 있음
      // false: 이전 화면 모두 지우고 이동
      // );
    }
  }

  // 🚀 이메일 유효성 검사
  String? _isEmailValid(String val) {
    if (val.isEmpty) return "이메일을 입력해주세요.";
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    // 정규표현식이 false이면 오류텍스트 return
    if (!regExp.hasMatch(val)) {
      return "이메일을 제대로 입력해주세요.";
    }
    return null;
  }

  // 🚀 비밀번호 유효성 검사
  String? _isPwValid(String val) {
    if (val.length < 8) return "비밀번호 길이는 8-20글자 입니다.";

    if (!val.contains(RegExp(r"[a-z]"))) return "비밀번호에 문자가 포함되어야 합니다.";
    if (!val.contains(RegExp(r"[0-9]"))) return "비밀번호에 숫자가 포함되어야 합니다.";
    if (!val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "비밀번호에 특수문자가 포함되어야 합니다.";
    }
    return null;
  }

  // 🚀 Scaffold 영역 클릭 함수
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClickScaffold,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("로그인"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Form(
            key: _formKey, // formKey
            child: Column(
              children: [
                Gaps.v80,
                TextFormField(
                  // 유효성 검증이 성공적이었을 때
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData["email"] = newValue;
                    }
                  },
                  // 유효성 검증
                  validator: (value) {
                    if (value == null) {
                      return "이메일을 입력해주세요.";
                    }
                    return _isEmailValid(value);
                  },
                  decoration: InputDecoration(
                    hintText: "이메일",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType:
                      TextInputType.emailAddress, // 키보드 입력창 email형식 제공
                  autocorrect: false, // 키보드 입력창에서 자동완성 false
                ),
                Gaps.v16,
                TextFormField(
                  // 유효성 검증이 성공적이였을 때
                  onSaved: (newValue) {
                    if (newValue != null) {
                      formData["pw"] = newValue;
                    }
                  },
                  // 유효성 검증
                  validator: (value) {
                    if (value == null) {
                      return "비밀번호를 입력해주세요.";
                    }
                    return _isPwValid(value);
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "비밀번호 (8-20글자, 특수문자/숫자/문자 포함)",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                  autocorrect: false, // 키보드 입력창에서 자동완성 false
                  onEditingComplete: _onSubmit, // 키보드 입력창에서 submit
                ),
                Gaps.v28,
                GestureDetector(
                  onTap: _onSubmit,
                  child: const FormButton(
                    disabled: false,
                    btnText: "로그인",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
