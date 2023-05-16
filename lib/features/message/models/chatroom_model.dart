class ChatRoomModel {
  String me;
  String you;

  ChatRoomModel({
    required this.me,
    required this.you,
  });

  // 유저모델 -> JSON 변환 메소드
  Map<String, dynamic> toJSON() {
    return {
      "me": me,
      "you": you,
    };
  }

  // JSON -> 유저모델 변환 메소드
  ChatRoomModel.fromJSON({required Map<String, dynamic> json})
      : me = json["me"],
        you = json["you"];
}
