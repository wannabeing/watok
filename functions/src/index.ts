import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

/* 
    Firestore 생성 이벤트를 감지하여.
    비디오 영상이 업로드 될 때마다 밑에 로직을 실행한다.
*/
export const listenFirestore = functions.firestore
  .document("videos/{videoId}")
  .onCreate(async (snapshot, context) => {
    const videoModel = snapshot.data(); // 사용자가 DB에 업로드한 비디오모델
    const storage = admin.storage(); // Firestore 스토리지
    const spawn = require("child-process-promise").spawn;

    /*  
        = c-p-p: 함수 실행되는 서버에서 리눅스 환경 명령어를 실행할 수 있게하는 패키지
        - ffmpeg: 영상/오디오 관련 변환 패키지  
        
        - 코드설명
        ffmpeg에게 업로드한 영상의 1초로 이동하여 150xauto 사이즈로 1장 캡쳐하여 다운로드한다.
        임시저장소에 videoUID.jpg로 저장한다.
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
        임시저장소에 있는 썸네일 jpg파일을
        스토리지 thumbs/videoUID.jpg로 저장한다.
    */
    await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbs/${snapshot.id}.jpg`,
    });

    // await snapshot.ref.update({ test: "Hello Functions" });
  });
