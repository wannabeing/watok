import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/pw_screen.dart';
import 'package:watok/features/authentication/view_models/auth_view_model.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';

class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({super.key});

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _email = '';

  // 🚀 이메일 제출 함수
  void _onSumbit() {
    if (_email.isEmpty || _isEmailValid() != null) return;

    // auth state에 email 저장
    ref.read(authForm.notifier).state = {
      "email": _email,
    };
    // 페이지 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PwScreen(),
      ),
    );
  }

  // 🚀 이메일 정규표현식 함수
  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    // 정규표현식이 false이면 오류텍스트 return
    if (!regExp.hasMatch(_email)) {
      return "이메일 형식이 아닙니다.";
    }
    return null;
  }

  // 🚀 Scaffold 영역 클릭 함수
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                "사용할 이메일",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // 키보드 입력창 email형식 제공
                autocorrect: false, // 키보드 입력창에서 자동완성 false
                onEditingComplete: _onSumbit, // 키보드 입력창에서 submit
                decoration: InputDecoration(
                  hintText: "사용할 이메일을 입력해주세요.",
                  errorText: _isEmailValid(), // 이메일 정규표현식 함수 적용
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
              GestureDetector(
                onTap: _onSumbit,
                child: FormButton(
                    btnText: "다음",
                    disabled: _email.isEmpty || _isEmailValid() != null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
