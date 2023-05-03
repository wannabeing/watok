class UserModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final bool avatarUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.avatarUrl,
  });

  // 유저모델 빈 생성자 생성 메소드
  UserModel.empty()
      : uid = "",
        email = "whoami@who.am.i",
        name = "넌누구인가",
        bio = "",
        link = "",
        birthday = "",
        avatarUrl = false;

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
        avatarUrl = json["avatarUrl"];

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
    );
  }
}
