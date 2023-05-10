import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/features/videos/models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // 스토리지에 비디오파일 저장 함수
  Future<TaskSnapshot> uploadStorage(
    File video,
    String uid,
    String title,
  ) async {
    final videoRef = _storage.ref().child("videos/$uid/$title"); // 파일경로 및 이름 설정
    return await videoRef.putFile(video); // 파일 업로드
  }

  // DB에 비디오모델 저장 함수
  Future<void> saveVideo(VideoModel video) async {
    await _db.collection("videos").add(video.toJSON());
  }

  /*
    DB에 저장된 비디오 모델 내림차순 2개 가져오기
    
    Q)왜 2개? 요청때마다 모든 비디오를 가져오는게 아니라 보여줄 비디오 1개, 예비 1개를 가져옴
    그 이후에 다시 요청 시, 다시 2개를 기존 비디오리스트에 추가함

    Q) lastCreatedAt?
      해당 변수에는 마지막 비디오의 createdAt이 들어있다.
      변수가 null이 아닐 경우, 이후의 값 2개를 가져온다.
  */
  Future<QuerySnapshot<Map<String, dynamic>>> getVideos(
      {int? lastCreatedAt}) async {
    // 쿼리문 변수
    final videoQuery = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);

    if (lastCreatedAt == null) {
      return await videoQuery.get();
    } else {
      return videoQuery.startAfter([lastCreatedAt]).get();
    }
  }

  // 비디오 좋아요 저장 함수
  Future<void> likeVideo({required String vid, required String uid}) async {
    final query = _db.collection("likes").doc("${vid}999$uid");
    final like = await query.get();

    // 좋아요 컬렉션이 있을 때는 컬렉션 삭제
    if (like.exists) {
      query.delete();
    }
    // 좋아요 컬렉션 생성
    else {
      await query.set({
        "videoId": vid,
        "userId": uid,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // 현재유저가 비디오 좋아요 눌렀는지 체크 함수
  Future<bool> isLikeVideo({required String vid, required String uid}) async {
    final isLike = await _db.collection("likes").doc("${vid}999$uid").get();
    return isLike.exists;
  }

  // GETTER 비디오 함수
  Future<Map<String, dynamic>?> getVideo({required String vid}) async {
    if (vid == "") return null;
    final video = await _db.collection("videos").doc(vid).get();
    return video.data();
  }
}

final videoRepository = Provider((ref) => VideoRepository());
