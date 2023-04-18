import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/loginform_screen.dart';
import 'package:watok/features/authentication/widgets/auth_button.dart';
import 'package:watok/utils.dart';

class LoginScreen extends StatelessWidget {
  static String route = "/login";
  const LoginScreen({super.key});

  // 회원가입 텍스트 클릭 시, 회원가입 페이지 이동
  void onClickSignUp(BuildContext context) {
    Navigator.of(context).pop();
  }

  // 로그인 폼 페이지 이동
  void _onClickEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                "와톡 시작하기",
                style: TextStyle(
                  fontSize: Sizes.size28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "와톡은 수많은 대출고민을 해결하고 있어요 와톡은 수많은 투자고민을 해결하고 있어요",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.user),
                text: "이메일로 시작하기",
                onClickFn: _onClickEmail,
              ),
              Gaps.v20,
              AuthButton(
                icon: const FaIcon(FontAwesomeIcons.apple),
                text: "애플계정으로 시작하기",
                onClickFn: _onClickEmail,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color:
            isDarkTheme(context) ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size48,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("계정이 없으신가요?"),
              Gaps.h5,
              GestureDetector(
                onTap: () => onClickSignUp(context),
                child: Text(
                  "회원가입",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
