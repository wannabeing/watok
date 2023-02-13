import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/loginform_screen.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
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
  void _onClickNext() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
      (route) => false, // 이전 화면 모두 지우고 이동
    );
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
    return Scaffold(
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
              child: const FormButton(
                disabled: false,
                btnText: "다음",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
    );
  }
}
