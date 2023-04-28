import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/birthday_screen.dart';
import 'package:watok/features/authentication/view_models/auth_view_model.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';

class PwScreen extends ConsumerStatefulWidget {
  const PwScreen({super.key});

  @override
  ConsumerState<PwScreen> createState() => _PwScreenState();
}

class _PwScreenState extends ConsumerState<PwScreen> {
  final TextEditingController _pwController = TextEditingController();

  String _pw = '';
  bool _isObscure = true;

  // 🚀 다음 클릭 함수
  void _onSumbit() {
    if (!_isPwValid() || !_isPwLengthValid()) return;

    // auth state에 pw 저장
    final state = ref.read(authForm.notifier).state;
    ref.read(authForm.notifier).state = {
      ...state,
      "pw": _pw,
    };

    // 페이지 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  // 🚀 인풋창 초기화 함수
  void _onClear() {
    _pwController.clear();
  }

  // 🚀 obscure 변수 상태 변경 함수
  void _toggleObscure() {
    _isObscure = !_isObscure;
    setState(() {});
  }

  // 🚀 비밀번호 정규표현식 함수
  bool _isPwValid() {
    if (!_pw.contains(RegExp(r"[a-z]"))) return false;
    if (!_pw.contains(RegExp(r"[0-9]"))) return false;
    if (!_pw.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  // 🚀 비밀번호 길이 체크 함수
  bool _isPwLengthValid() {
    return _pw.isNotEmpty && _pw.length > 8;
  }

  // 🚀 Scaffold 영역 클릭 함수
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    _pwController.addListener(() {
      setState(() {
        _pw = _pwController.text;
      });
    });
  }

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClickScaffold, // input창 이외에 곳 클릭 시
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "회원가입",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v60,
              const Text(
                "사용할 비밀번호",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _pwController,
                autocorrect: false, // 키보드 입력창에서 자동완성 false
                obscureText: _isObscure, // 입력창 비밀번호 표시
                onEditingComplete: _onSumbit, // 키보드 입력창에서 submit
                decoration: InputDecoration(
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onClear,
                        child: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Colors.grey.shade500,
                          size: Sizes.size18,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: _toggleObscure,
                        child: FaIcon(
                          _isObscure
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: Sizes.size18,
                        ),
                      ),
                    ],
                  ),
                  hintText: "사용할 비밀번호를 입력해주세요.",
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
              ),
              Gaps.v16,
              const Text("비밀번호는 아래 조건을 만족해야합니다."),
              Gaps.v16,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size18,
                    color: _isPwLengthValid()
                        ? Colors.green.shade500
                        : Colors.grey.shade500,
                  ),
                  Gaps.h10,
                  const Text("8-20글자"),
                ],
              ),
              Gaps.v16,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    size: Sizes.size18,
                    color: _isPwValid()
                        ? Colors.green.shade500
                        : Colors.grey.shade500,
                  ),
                  Gaps.h10,
                  const Text("숫자/문자/특수문자 조합"),
                ],
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSumbit,
                child: FormButton(
                  btnText: "다음",
                  disabled: !_isPwValid() || !_isPwLengthValid(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
