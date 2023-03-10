import 'package:flutter/material.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/features/authentication/widgets/form_button.dart';

import '../../constants/sizes.dart';
import 'email_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  String _username = '';

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  // ๐ Next ํด๋ฆญ
  void _onClickNext() {
    // username์ด ๋น์ด์๊ฑฐ๋ ๊ธธ์ด๊ฐ 3์ดํ์ผ ๊ฒฝ์ฐ return
    if (_username.isEmpty || _username.length < 3) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ํ์๊ฐ์",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v60,
            const Text(
              "์ฌ์ฉํ  ๋๋ค์",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            const Text(
              "๋์ค์ ๋ฐ๊ฟ ์ ์์ต๋๋ค.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "๋๋ค์ (3๊ธ์ ์ด์)",
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
                btnText: "๋ค์",
                disabled: _username.length < 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
