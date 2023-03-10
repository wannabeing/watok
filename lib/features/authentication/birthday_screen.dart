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

  // π Next ν΄λ¦­
  void _onClickNext() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
      (route) => false,
      // routeμλ μ΄μ  νλ©΄λ€μ μ λ³΄κ° λ΄κ²¨ μμ
      // false: μ΄μ  νλ©΄ λͺ¨λ μ§μ°κ³  μ΄λ
    );
  }

  // π λ μ§ κ³μ° ν¨μ
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
          "νμκ°μ",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v60,
            const Text(
              "μμΌμ μλ ₯ν΄μ£ΌμΈμ!",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              "μμΌμ λ€λ₯Έμ¬λλ€μκ² λ³΄μ΄μ§ μμ΅λλ€.",
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
                btnText: "λ€μ",
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
