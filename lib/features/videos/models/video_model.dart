class VideoModel {
  String vid;
  String uid;
  String uname;
  String title;
  String desc;
  String fileUrl;
  String thumbUrl;
  int likes;
  int comments;
  int createdAt;

  VideoModel({
    required this.vid,
    required this.uid,
    required this.uname,
    required this.title,
    required this.desc,
    required this.fileUrl,
    required this.thumbUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  // 비디오모델 JSON 변환 메소드
  Map<String, dynamic> toJSON() {
    return {
      "vid": vid,
      "uid": uid,
      "uname": uname,
      "title": title,
      "desc": desc,
      "fileUrl": fileUrl,
      "thumbUrl": thumbUrl,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
    };
  }

  // JSON -> 비디오모델 변환 메소드
  VideoModel.fromJSON(
      {required Map<String, dynamic> json, required String videoId})
      : vid = videoId,
        uid = json["uid"],
        uname = json["uname"],
        title = json["title"],
        desc = json["desc"],
        fileUrl = json["fileUrl"],
        thumbUrl = json["thumbUrl"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"];
}
