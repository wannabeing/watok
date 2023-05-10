class MsgModel {
  String uid;
  String text;
  int createdAt;

  MsgModel({
    required this.uid,
    required this.text,
    required this.createdAt,
  });

  // 유저모델 -> JSON 변환 메소드
  Map<String, dynamic> toJSON() {
    return {
      "uid": uid,
      "text": text,
      "createdAt": createdAt,
    };
  }

  // JSON -> 유저모델 변환 메소드
  MsgModel.fromJSON({required Map<String, dynamic> json})
      : uid = json["uid"],
        text = json["text"],
        createdAt = json["createdAt"];
}
