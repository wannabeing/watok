import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/videos/models/video_model.dart';
import 'package:watok/features/videos/repos/video_repo.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<bool, String> {
  late VideoRepository _videoRepository;
  late String _videoId;
  late User _user;
  bool _isLike = false;

  // 초기화, 현재 유저가 좋아요 누른 여부 return
  @override
  FutureOr<bool> build(String arg) async {
    _user = ref.read(authRepository).user!;
    _videoId = arg;
    _videoRepository = ref.read(videoRepository);

    _isLike = await ref
        .read(videoRepository)
        .isLikeVideo(vid: _videoId, uid: _user.uid);
    return _isLike;
  }

  // 비디오 좋아요 기능
  Future<void> likeVideo() async {
    final user = ref.read(authRepository).user!; // 현재 로그인 유저

    await _videoRepository.likeVideo(
      vid: _videoId,
      uid: user.uid,
    );
    _isLike = !_isLike;
    state = AsyncValue.data(_isLike);
  }

  // 비디오 정보 가져오기 함수
  Future<VideoModel?> getVideo() async {
    final fromDB = await _videoRepository.getVideo(vid: _videoId);
    if (fromDB != null) {
      return VideoModel.fromJSON(json: fromDB, videoId: _videoId);
    }
    return null;
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, bool, String>(
  () => VideoPostViewModel(),
);
