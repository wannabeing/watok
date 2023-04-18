import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/videos/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});
  static String route = "recording";

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with WidgetsBindingObserver {
  bool _isAccepted = false; // 캠/마이크 권한 여부
  bool _isCamMode = true; // 카메라 전/후면모드 설정 (true: 전면모드)
  bool _isFlashed = false; // 카메라 플래쉬 설정 (false: 안켜짐)
  bool _isAppLeaved = false; // 사용자가 앱을 떠났는지 여부 (false: 안떠남)

  late CameraController _cameraController;

  // 카메라/마이크 권한 요청 함수
  Future<void> initPermission() async {
    final camPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final isCamDenied =
        camPermission.isDenied || camPermission.isPermanentlyDenied;
    final isMicDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!isCamDenied && !isMicDenied) {
      _isAccepted = true;

      await initCam();
      setState(() {});
    } else {
      return;
    }
  }

  // 카메라 초기화 함수
  Future<void> initCam() async {
    final cam = await availableCameras();

    _cameraController = CameraController(
      cam[_isCamMode ? 0 : 1],
      ResolutionPreset.veryHigh,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    ); // 카메라 전/후면모드 세팅
    await _cameraController.initialize();
    // IOS 카메라를 위한 세팅
    await _cameraController.prepareForVideoRecording();
  }

  // 카메라 전/후면모드 변경 함수
  Future<void> _toggleCamMode() async {
    _isCamMode = !_isCamMode;

    await initCam();
    setState(() {});
  }

  // 카메라 플래쉬 변경 함수
  Future<void> _toggleFlashMode() async {
    if (!_isCamMode) return; // 카메라 후면모드일 경우, 함수 종료

    if (_isFlashed) {
      await _cameraController.setFlashMode(FlashMode.off);
    } else {
      await _cameraController.setFlashMode(FlashMode.torch);
    }
    _isFlashed = !_isFlashed;
    setState(() {});
  }

  // 녹화 시작 함수
  Future<void> _startRecording() async {
    if (_cameraController.value.isRecordingVideo) return; // 녹화 중일 경우, 함수 종료

    await _cameraController.startVideoRecording(); // 녹화 시작
  }

  // 녹화 종료 함수
  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) {
      return; // 녹화 중이지 않을 경우, 함수 종료
    }

    final video = await _cameraController.stopVideoRecording(); // 녹화된 영상 변수

    if (!mounted) return; // context를 async에서 사용했을 때 생기는 문제때문에 추가
    context.push(
      VideoPreviewScreen.route,
      extra: VideoArgs(
        video: video,
        isPicked: false,
      ),
    ); // 녹화 종료 후, 프리뷰 페이지 이동
  }

  // 디바이스 갤러리 함수
  Future<void> _initGallery() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video == null) return;
    if (!mounted) return; // context를 async에서 사용했을 때 생기는 문제때문에 추가
    context.push(
      VideoPreviewScreen.route,
      extra: VideoArgs(
        video: video,
        isPicked: true,
      ),
    ); // 녹화 종료 후, 프리뷰 페이지 이동
  }

  // 디바이스 카메라 함수 (임시)
  Future<void> _takePic() async {
    await ImagePicker().pickImage(source: ImageSource.camera);
  }

  // 사용자가 앱을 떠났음을 감지하는 함수
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!_isAccepted || !_cameraController.value.isInitialized) return;

    // 앱을 떠났을 때
    if (state == AppLifecycleState.paused) {
      _isAppLeaved = true;
      setState(() {});
      _cameraController.dispose();
    }
    // 앱에 다시 돌아왔을 때
    else if (state == AppLifecycleState.resumed) {
      _isAppLeaved = false;
      setState(() {});
      await initPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    initPermission();
    WidgetsBinding.instance.addObserver(this); // 사용자가 앱을 떠났음을 감지하기 위해 추가
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _isAccepted && _cameraController.value.isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  if (!_isAppLeaved)
                    CameraPreview(
                      _cameraController,
                    ),
                  Positioned(
                    bottom: Sizes.size10,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: _toggleCamMode,
                      icon: const Icon(Icons.cameraswitch_sharp),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "초기화 중...",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.18,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              color: Colors.white,
              onPressed: _toggleFlashMode,
              icon: Icon(
                (_isFlashed
                    ? Icons.flashlight_on_outlined
                    : Icons.flashlight_off_outlined),
              ),
            ),
            IconButton(
              color: Colors.white,
              onPressed: _initGallery,
              icon: const FaIcon(FontAwesomeIcons.image),
            ),
            GestureDetector(
              onTapDown: (details) => _startRecording(),
              onTapUp: (details) => _stopRecording(),
              child: Container(
                padding: const EdgeInsets.all(Sizes.size10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: Sizes.size3,
                  ),
                  borderRadius: BorderRadius.circular(Sizes.size44),
                ),
                child: const FaIcon(
                  size: Sizes.size32,
                  color: Colors.white,
                  FontAwesomeIcons.video,
                ),
              ),
            ),
            IconButton(
              color: Colors.white,
              onPressed: _takePic,
              icon: const FaIcon(FontAwesomeIcons.camera),
            ),
            IconButton(
              color: Colors.white,
              onPressed: _toggleCamMode,
              icon: const FaIcon(FontAwesomeIcons.cameraRotate),
            ),
          ],
        ),
      ),
    );
  }
}
