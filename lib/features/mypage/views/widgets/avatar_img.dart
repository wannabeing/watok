import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/mypage/view_models/avatar_view_model.dart';

class AvatarWdt extends ConsumerWidget {
  final String name;
  final String uid;
  final bool avatarUrl;

  const AvatarWdt({
    super.key,
    required this.name,
    required this.uid,
    required this.avatarUrl,
  });

  Future<void> _onTap(WidgetRef ref) async {
    // 선택한 이미지 파일
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 640,
      maxHeight: 640,
    );
    if (picked != null) {
      final file = File(picked.path);
      ref.read(avatarProvider.notifier).upload(file); // 이미지 업로드
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(avatarProvider).isLoading
        ? SizedBox(
            width: Sizes.size36,
            height: Sizes.size36,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          )
        : GestureDetector(
            onTap: () async => await _onTap(ref),
            child: CircleAvatar(
              maxRadius: Sizes.size52,
              backgroundColor: Colors.grey.shade500,
              foregroundImage: avatarUrl
                  ? NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/my-watok.appspot.com/o/avatars%2F$uid?alt=media&token=785eee75-56d1-41a9-b0f4-f18d04767bc0",
                    )
                  : null,
              child: Text(name),
            ),
          );
  }
}
