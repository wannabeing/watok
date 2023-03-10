import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/birthday_screen.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';

class PwScreen extends StatefulWidget {
  const PwScreen({super.key});

  @override
  State<PwScreen> createState() => _PwScreenState();
}

class _PwScreenState extends State<PwScreen> {
  final TextEditingController _pwController = TextEditingController();

  String _pw = '';
  bool _isObscure = true;

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

  // π λ€μ ν΄λ¦­ ν¨μ
  void _onSumbit() {
    if (!_isPwValid() || !_isPwLengthValid()) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  // π μΈνμ°½ μ΄κΈ°ν ν¨μ
  void _onClear() {
    _pwController.clear();
  }

  // π obscure λ³μ μν λ³κ²½ ν¨μ
  void _toggleObscure() {
    _isObscure = !_isObscure;
    setState(() {});
  }

  // π λΉλ°λ²νΈ μ κ·ννμ ν¨μ
  bool _isPwValid() {
    if (!_pw.contains(RegExp(r"[a-z]"))) return false;
    if (!_pw.contains(RegExp(r"[0-9]"))) return false;
    if (!_pw.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  // π λΉλ°λ²νΈ κΈΈμ΄ μ²΄ν¬ ν¨μ
  bool _isPwLengthValid() {
    return _pw.isNotEmpty && _pw.length > 8;
  }

  // π Scaffold μμ­ ν΄λ¦­ ν¨μ
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClickScaffold, // inputμ°½ μ΄μΈμ κ³³ ν΄λ¦­ μ
      child: Scaffold(
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
                "μ¬μ©ν  λΉλ°λ²νΈ",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _pwController,
                autocorrect: false, // ν€λ³΄λ μλ ₯μ°½μμ μλμμ± false
                obscureText: _isObscure, // μλ ₯μ°½ λΉλ°λ²νΈ νμ
                onEditingComplete: _onSumbit, // ν€λ³΄λ μλ ₯μ°½μμ submit
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
                  hintText: "μ¬μ©ν  λΉλ°λ²νΈλ₯Ό μλ ₯ν΄μ£ΌμΈμ.",
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
              const Text("λΉλ°λ²νΈλ μλ μ‘°κ±΄μ λ§μ‘±ν΄μΌν©λλ€."),
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
                  const Text("8-20κΈμ"),
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
                  const Text("μ«μ/λ¬Έμ/νΉμλ¬Έμ μ‘°ν©"),
                ],
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSumbit,
                child: FormButton(
                  btnText: "λ€μ",
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
