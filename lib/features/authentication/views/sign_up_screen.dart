import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/common/widgets/darkTheme_config.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/views/email_screen.dart';
import 'package:watok/features/authentication/views/login_screen.dart';
import 'package:watok/features/authentication/views/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  static String route = "/signup";
  const SignUpScreen({super.key});

  // 로그인 페이지 이동 함수
  void _onClickLogin(BuildContext context) {
    context.push(LoginScreen.route);
  }

  // 회원가입 페이지 이동 함수
  void _onClickEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
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
                    "와톡 회원가입",
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
                    text: "이메일로 회원가입",
                    onClickFn: _onClickEmail,
                  ),
                  Gaps.v20,
                  AuthButton(
                    icon: const FaIcon(FontAwesomeIcons.apple),
                    text: "애플계정으로 회원가입",
                    onClickFn: _onClickEmail,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: darkThemeConfig.value
                ? Colors.grey.shade900
                : Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size48,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("계정이 있으신가요?"),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onClickLogin(context),
                    child: Text(
                      "로그인",
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
      },
    );
  }
}
