import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watok/features/mypage/models/user_model.dart';

class UserRepository {
  // DB
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // CREATE 프로필
  Future<void> createProfile(UserModel user) async {
    /* 
      firestore에 users/uid/{} 에 저장
      firesotre에 JSON으로 저장해야 함 -> toJSON() 함수 사용
    */
    await _db.collection("users").doc(user.uid).set(user.toJSON());
  }

  // GETTER 프로필
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final user = await _db.collection("users").doc(uid).get();
    return user.data();
  }

  // SETTER 프로필

  // UPLOAD 프로필 이미지
  Future<void> uploadAvatarImg(File img, String uid) async {
    final avtRef = _storage.ref().child("avatars/$uid"); // 파일경로 설정
    await avtRef.putFile(img); // 파일 업로드
  }

  /* 
    UPDATE 프로필
      - Firebase는 JSON 형식으로 저장해야하므로 data 인자를 Map으로 받음

      - update()
        문서의 데이터를 업데이트합니다. 데이터는 기존 문서 데이터와 병합됩니다.
  */
  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }
}

final userRepository = Provider((ref) => UserRepository());
