import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/common/widgets/navigations/main_nav_screen.dart';
import 'package:watok/features/mypage/view_models/user_view_model.dart';
import 'package:watok/features/videos/models/video_model.dart';
import 'package:watok/features/videos/repos/video_repo.dart';
import 'package:watok/features/videos/view_models/video_timeline_vm.dart';

class VideoUploadViewModel extends AsyncNotifier<void> {
  late VideoRepository _videoRepository;

  // 초기화 및 선언
  @override
  FutureOr<void> build() {
    _videoRepository = ref.read(videoRepository);
  }

  // 비디오 업로드 요청 함수
  Future<void> uploadVideo(
      File video, String title, String desc, BuildContext context) async {
    state = const AsyncValue.loading();

    final user = ref.read(userProvider).value;
    if (user == null) return;

    state = await AsyncValue.guard(() async {
      // storage에 비디오 업로드
      final task = await _videoRepository.uploadStorage(video, user.uid, title);

      // DB에 비디오 모델 저장
      if (task.metadata != null) {
        await _videoRepository.saveVideo(
          VideoModel(
            vid: "",
            uid: user.uid,
            uname: user.name,
            title: title,
            desc: desc,
            fileUrl: await task.ref.getDownloadURL(),
            thumbUrl: "",
            likes: 0,
            comments: 0,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
      // 타임라인 새로고침
      await ref.read(timelineProvider.notifier).refreshVideos();
      // 메인페이지로 이동
      if (!context.mounted) return;
      context.go(MainNavScreen.route);
    });
  }
}

final videoUploadProvider = AsyncNotifierProvider<VideoUploadViewModel, void>(
    () => VideoUploadViewModel());
