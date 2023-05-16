class UserModel {
  String uid;
  String email;
  String name;
  String bio;
  String link;
  String birthday;
  bool avatarUrl;
  int createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.avatarUrl,
    required this.createdAt,
  });

  // 유저모델 빈 생성자 생성 메소드
  UserModel.empty()
      : uid = "",
        email = "whoami@who.am.i",
        name = "익명",
        bio = "자기소개",
        link = "링크",
        birthday = "",
        avatarUrl = false,
        createdAt = DateTime.now().millisecondsSinceEpoch;

  // 유저모델 JSON 변환 메소드
  Map<String, dynamic> toJSON() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "birthday": birthday,
      "avatarUrl": avatarUrl,
      "createdAt": createdAt,
    };
  }

  // JSON -> 유저모델 변환 메소드
  UserModel.fromJSON(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        birthday = json["birthday"],
        avatarUrl = json["avatarUrl"],
        createdAt = json["createdAt"];

  /* 
    유저모델 복사 및 덮어쓰기 메소드
    특정 값만 수정할 경우, 나머지 값은 this로 채움
  */
  UserModel coverModel({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    bool? avatarUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }

  // 유저모델 받아서 생성하는 메소드
  UserModel.createModel({required UserModel newModel})
      : uid = newModel.uid,
        email = newModel.email,
        name = newModel.name,
        bio = newModel.bio,
        link = newModel.link,
        birthday = newModel.birthday,
        avatarUrl = newModel.avatarUrl,
        createdAt = newModel.createdAt;
}
