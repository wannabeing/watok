import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/views/widgets/form_button.dart';
import 'package:watok/features/mypage/view_models/user_view_model.dart';

class EditUserProfileWdt extends ConsumerStatefulWidget {
  const EditUserProfileWdt({super.key});

  @override
  ConsumerState<EditUserProfileWdt> createState() => _EditUserProfileWdtState();
}

class _EditUserProfileWdtState extends ConsumerState<EditUserProfileWdt> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 폼 데이터 변수
  final Map<String, String> formData = {};

  // 수정하기 함수
  void _onSubmit() async {
    bool? isVal = _formKey.currentState?.validate(); // 폼 데이터유효성 검사

    if (isVal == true) {
      _formKey.currentState?.save();

      // 수정하기 요청
      await ref.read(userProvider.notifier).updateProfile(
            formData["name"]!,
            formData["bio"]!,
            formData["link"]!,
          );
      // 페이지 뒤로가기
      if (!mounted) return;
      context.pop();
    }
  }

  // 텍스트 유효성 검사
  String? _isTextValid(String val) {
    if (val.isEmpty) return "비어있어요.";
    if (val.length > 30) return "30자 이하로 입력해주세요.";
    return null;
  }

  // Scaffold 영역 클릭 함수
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProvider).isLoading;
    return ref.watch(userProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (user) => GestureDetector(
            onTap: _onClickScaffold,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('프로필 수정'),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gaps.v20,
                      TextFormField(
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData["name"] = newValue;
                          }
                        },
                        validator: (value) {
                          if (value == null) return "공백입니다.";
                          return _isTextValid(value);
                        },
                        controller: TextEditingController(text: user.name),
                        decoration: InputDecoration(
                          labelText: '닉네임',
                          hintText: "닉네임을 입력해주세요. (30자 이하)",
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
                        autocorrect: false, // 키보드 입력창에서 자동완성 false
                      ),
                      Gaps.v16,
                      TextFormField(
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData["bio"] = newValue;
                          }
                        },
                        validator: (value) {
                          if (value == null) return "공백입니다.";
                          return _isTextValid(value);
                        },
                        controller: TextEditingController(text: user.bio),
                        decoration: InputDecoration(
                          labelText: '자기소개',
                          hintText: "자신을 소개해주세요. (30자 이하)",
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
                        autocorrect: false, // 키보드 입력창에서 자동완성 false
                      ),
                      Gaps.v16,
                      TextFormField(
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData["link"] = newValue;
                          }
                        },
                        validator: (value) {
                          if (value == null) return "공백입니다.";
                          return _isTextValid(value);
                        },
                        controller: TextEditingController(text: user.link),
                        decoration: InputDecoration(
                          labelText: 'URL',
                          hintText: "운영중인 홈페이지를 입력해주세요. (30자 이하)",
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
                        autocorrect: false, // 키보드 입력창에서 자동완성 false
                      ),
                      Gaps.v28,
                      GestureDetector(
                        onTap: _onSubmit,
                        child: FormButton(
                          btnText: "수정하기",
                          disabled: isLoading,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
