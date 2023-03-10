import 'package:flutter/material.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/pw_screen.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _email = '';

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

  // π λ€μ ν΄λ¦­ ν¨μ
  void _onSumbit() {
    if (_email.isEmpty || _isEmailValid() != null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PwScreen(),
      ),
    );
  }

  // π μ΄λ©μΌ μ κ·ννμ ν¨μ
  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    // μ κ·ννμμ΄ falseμ΄λ©΄ μ€λ₯νμ€νΈ return
    if (!regExp.hasMatch(_email)) {
      return "μ΄λ©μΌ νμμ΄ μλλλ€.";
    }
    return null;
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
                "μ¬μ©ν  μ΄λ©μΌ",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // ν€λ³΄λ μλ ₯μ°½ emailνμ μ κ³΅
                autocorrect: false, // ν€λ³΄λ μλ ₯μ°½μμ μλμμ± false
                onEditingComplete: _onSumbit, // ν€λ³΄λ μλ ₯μ°½μμ submit
                decoration: InputDecoration(
                  hintText: "μ¬μ©ν  μ΄λ©μΌμ μλ ₯ν΄μ£ΌμΈμ.",
                  errorText: _isEmailValid(), // μ΄λ©μΌ μ κ·ννμ ν¨μ μ μ©
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
                    btnText: "λ€μ",
                    disabled: _email.isEmpty || _isEmailValid() != null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
