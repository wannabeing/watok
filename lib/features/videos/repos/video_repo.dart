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
      File video, String uid, String title) async {
    final videoRef = _storage.ref().child("videos/$uid/$title"); // 파일경로 및 이름 설정
    return await videoRef.putFile(video); // 파일 업로드
  }

  // DB에 비디오모델 저장 함수
  Future<void> saveVideo(VideoModel video) async {
    await _db.collection("videos").add(video.toJSON());
  }
}

final videoRepository = Provider((ref) => VideoRepository());
