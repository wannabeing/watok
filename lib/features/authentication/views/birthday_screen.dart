import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/view_models/auth_view_model.dart';
import 'package:watok/features/authentication/views/widgets/form_button.dart';
import 'package:watok/features/onboard/interests_screen.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  late DateTime initDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    initDate = DateTime(now.year - 12);
    _setDate(initDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  // 🚀 Next 클릭
  void _onClickNext() async {
    final state = ref.read(authForm.notifier).state;

    // auth state에 birthday 저장
    ref.read(authForm.notifier).state = {
      ...state,
      "birthday": _birthdayController.value.text,
    };

    // firebase 계정생성 요청
    await ref.read(authProvider.notifier).createUser();

    // goRouter에서 파라미터 보내면서 페이지 이동
    if (!mounted) return;
    context.go(
      InterestsScreen.route,
      extra: LoginArgs(
        email: state["email"],
        pw: state["pw"],
      ),
    );
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const LoginFormScreen(),
    //   ),
    //   (route) => false,
    //   // route에는 이전 화면들의 정보가 담겨 있음
    //   // false: 이전 화면 모두 지우고 이동
    // );
  }

  // 🚀 날짜 계산 함수
  void _setDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(
      text: textDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "회원가입",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v60,
                const Text(
                  "생일을 입력해주세요!",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v8,
                const Text(
                  "생일은 다른사람들에게 보이지 않습니다.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v16,
                TextField(
                  enabled: false,
                  controller: _birthdayController,
                  decoration: InputDecoration(
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
                  onTap: _onClickNext,
                  child: FormButton(
                    disabled: ref.watch(authProvider).isLoading,
                    btnText: "다음",
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(
              top: Sizes.size32,
              bottom: Sizes.size48,
            ),
            child: SizedBox(
              height: 300,
              child: CupertinoDatePicker(
                maximumDate: initDate,
                initialDateTime: initDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: _setDate,
              ),
            ),
          ),
        ),
        // 🔥 로딩창
        if (ref.watch(authProvider).isLoading) ...[
          Opacity(
            opacity: 0.3,
            child: SizedBox.expand(
              child: Container(color: Colors.black),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ],
    );
  }
}
