import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

/* 
  DB에 비디오객체 생성 이벤트를 감지하여,
  스토리지에 저장된 영상파일url을 생성된 비디오 객체에 업뎃하는 로직을 실행한다.
*/
export const listenFirestore = functions
  .region("asia-northeast3")
  .firestore.document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const videoModel = snapshot.data(); // 사용자가 DB에 업로드한 비디오 객체 데이터
    const db = admin.firestore(); // DB 접근 변수
    const storage = admin.storage(); // 스토리지 접근 변수
    const spawn = require("child-process-promise").spawn; // node 자식프로세스 생성

    /*  
      - c-p-p: 함수 실행되는 서버에서 리눅스 환경 명령어를 실행할 수 있게하는 패키지
      - ffmpeg: 영상/오디오 관련 변환 패키지  
        
      - 코드설명
      이 함수가 실행되는 서버(cloud)에서 
      ffmpeg에게 업로드한 영상의 1초로 이동하고 150xauto 사이즈로 1장 캡쳐하여 다운로드한다.
      코드가 실행된 임시저장소에 videoID.jpg로 저장한다.
    */
    await spawn("ffmpeg", [
      "-i",
      videoModel.fileUrl,
      "-ss",
      "00:00:01.000",
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1",
      `/tmp/${snapshot.id}.jpg`,
    ]);
    /*
      - 코드설명
      임시저장소에 있는 썸네일 jpg파일을 스토리지에 thumbs/videoID.jpg로 저장한다.
        
      스토리지에 저장된 파일을 public 설정으로 변경한 뒤,
      기존 DB 비디오 모델 vid와 thumbsUrl에 스토리지 jpg파일링크를 업데이트한다.
    */
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbs/${snapshot.id}.jpg`,
    });

    await file.makePublic();
    await snapshot.ref.update({ vid: snapshot.id, thumbUrl: file.publicUrl() });

    /*
      - 코드설명  
      DB 유저 객체 안에 비디오 폴더를 생성하여 쿼리요청시 부하를 최소화한다.
      비디오폴더에는 비디오모델의 간소화된 정보를 저장한다.

      ex) users/:userId/myvideos/:videoId/{ ... }
    */
    await db
      .collection("users")
      .doc(videoModel.uid)
      .collection("myvideos")
      .doc(snapshot.id)
      .set({
        videoId: snapshot.id,
        title: videoModel.title,
        likes: videoModel.likes,
        thumbUrl: file.publicUrl(),
      });
  });

// 비디오 like 생성시
export const listenLikes = functions
  .region("asia-northeast3")
  .firestore.document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const likeId = snapshot.id;
    const [videoId, userId] = likeId.split("999");
    const videoModel = (
      await db.collection("videos").doc(videoId).get()
    ).data();

    // 비디오컬렉션 좋아요 1 증가
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(+1),
      });
    // 유저 컬렉션에 좋아요누른 비디오 추가 (mylikes)
    await db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(likeId)
      .set({
        videoId: videoId,
        title: videoModel!.title,
        likes: videoModel!.likes,
        thumbUrl: videoModel!.thumbUrl,
      });
  });
// 비디오 like 삭제시
export const listenDislike = functions
  .region("asia-northeast3")
  .firestore.document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const likeId = snapshot.id;
    const [videoId, userId] = likeId.split("999");

    // 비디오컬렉션 좋아요 1 감소
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(-1),
      });
    // 유저컬렉션에 좋아요누른 비디오 삭제 (mylikes)
    await db
      .collection("users")
      .doc(userId)
      .collection("likes")
      .doc(likeId)
      .delete();
  });
