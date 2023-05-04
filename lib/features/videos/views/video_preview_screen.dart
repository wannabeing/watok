import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/views/widgets/form_button.dart';
import 'package:watok/features/videos/view_models/video_timeline_vm.dart';
import 'package:watok/features/videos/view_models/video_upload_vm.dart';

class VideoArgs {
  final XFile video; // 녹화한 영상 파일
  final bool isPicked; // 내 디바이스 갤러리에서 가져왔는지 (false: 안가져왔음)

  VideoArgs({
    required this.video,
    required this.isPicked,
  });
}

class VideoPreviewScreen extends ConsumerStatefulWidget {
  static String route = "/preview";
  final VideoArgs videoArgs;

  const VideoPreviewScreen({
    super.key,
    required this.videoArgs,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late VideoPlayerController _videoPlayerController;
  bool _isSaved = false; // 녹화한 영상 저장했는지 (false: 저장 안했음)
  late final bool _isPicked =
      widget.videoArgs.isPicked; // 내 디바이스 갤러리에서 가져왔는지 (false: 안가져왔음)

  // 폼 데이터 변수
  final Map<String, String> formData = {};

  // 녹화한 영상 실행 함수
  Future<void> _playVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.videoArgs.video.path));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.setVolume(0);
    await _videoPlayerController.play();

    setState(() {});
  }

  // 디바이스에 녹화영상 저장하는 함수
  Future<void> _saveDevice() async {
    if (_isSaved) return; // 중복 저장 방지
    await GallerySaver.saveVideo(
      widget.videoArgs.video.path,
      albumName: "와톡",
    ); // 녹화영상 디바이스에 저장
    _isSaved = true; // 녹화한 영상 저장상태 설정
    setState(() {});
  }

  // 영상 업로드 함수
  void _uploadVideo() {
    ref.read(timelineProvider.notifier).addVideoModel();
  }

  void _onSubmit() async {
    bool? isVal = _formKey.currentState?.validate(); // 폼 데이터유효성 검사
    if (isVal == true) {
      _formKey.currentState?.save();

      // 업로드
      await ref.read(videoUploadProvider.notifier).uploadVideo(
            File(widget.videoArgs.video.path),
            formData["title"]!,
            formData["desc"]!,
            context,
          );
    }
  }

  // 텍스트 유효성 검사
  String? _isTextValid(String val) {
    if (val.isEmpty) return "비어있어요.";
    if (val.length > 30) return "30자 이하로 입력해주세요.";
    return null;
  }

  // Scaffold 영역 클릭 함수
  void _onClickScaffold() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    _playVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 비디오 업로드중 상태변수
    final uploading = ref.watch(videoUploadProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("비디오 업로드"),
        actions: [
          if (!_isPicked)
            IconButton(
              onPressed: _saveDevice,
              icon: _isSaved
                  ? const FaIcon(FontAwesomeIcons.check)
                  : const FaIcon(FontAwesomeIcons.download),
            ),
          IconButton(
            onPressed:
                ref.watch(timelineProvider).isLoading ? () {} : _uploadVideo,
            icon: ref.watch(timelineProvider).isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  )
                : const FaIcon(FontAwesomeIcons.arrowRight),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? GestureDetector(
              onTap: _onClickScaffold,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                    Gaps.v16,
                    const Text("영상 미리보기"),
                    Gaps.v10,
                    const Divider(
                      thickness: 0.7,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Gaps.v20,
                          TextFormField(
                            onSaved: (newValue) {
                              if (newValue != null) {
                                formData["title"] = newValue;
                              }
                            },
                            validator: (value) {
                              if (value == null) return "공백입니다.";
                              return _isTextValid(value);
                            },
                            decoration: InputDecoration(
                              labelText: '비디오 제목 추가',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            autocorrect: false, // 키보드 입력창에서 자동완성 false
                          ),
                          Gaps.v16,
                          TextFormField(
                            onSaved: (newValue) {
                              if (newValue != null) {
                                formData["desc"] = newValue;
                              }
                            },
                            validator: (value) {
                              if (value == null) return "공백입니다.";
                              return _isTextValid(value);
                            },
                            decoration: InputDecoration(
                              labelText: '비디오 설명 추가',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            cursorColor: Theme.of(context).primaryColor,
                            autocorrect: false, // 키보드 입력창에서 자동완성 false
                          ),
                          Gaps.v28,
                          GestureDetector(
                            onTap: _onSubmit,
                            child: uploading
                                ? const CircularProgressIndicator.adaptive()
                                : const FormButton(
                                    btnText: "업로드하기",
                                    disabled: false,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
