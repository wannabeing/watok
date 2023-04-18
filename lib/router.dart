import 'package:go_router/go_router.dart';
import 'package:watok/features/videos/video_preview_screen.dart';
import 'package:watok/features/videos/video_recording_screen.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const VideoRecordingScreen(),
    ),
    GoRoute(
      path: VideoPreviewScreen.route,
      builder: (context, state) {
        return VideoPreviewScreen(
          videoArgs: state.extra as VideoArgs,
        );
      },
    ),
    // GoRoute(
    //   path: SignUpScreen.route,
    //   builder: (context, state) => const SignUpScreen(),
    //   routes: [
    //     GoRoute(
    //       name: EmailScreen.route,
    //       path: EmailScreen.route,
    //       builder: (context, state) => const EmailScreen(),
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   path: LoginScreen.route,
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   path: LoginFormScreen.route,
    //   builder: (context, state) => const LoginFormScreen(),
    // ),
    // GoRoute(
    //   path: InterestsScreen.route,
    //   builder: (context, state) {
    //     return InterestsScreen(
    //       form: state.extra as FormArgs,
    //     );
    //   },
    // ),
  ],
);
