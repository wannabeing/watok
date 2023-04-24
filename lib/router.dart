import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/common/widgets/navigations/main_nav_screen.dart';
import 'package:watok/features/authentication/login_screen.dart';
import 'package:watok/features/authentication/sign_up_screen.dart';
import 'package:watok/features/message/activity_screen.dart';
import 'package:watok/features/message/dm_detail_screen.dart';
import 'package:watok/features/message/dm_screen.dart';
import 'package:watok/features/onboard/interests_screen.dart';

import 'features/videos/views/video_create_screen.dart';

final goRouter = GoRouter(
  initialLocation: MainNavScreen.route,
  routes: [
    GoRoute(
      path: LoginScreen.route,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignUpScreen.route,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: InterestsScreen.route,
      builder: (context, state) {
        return InterestsScreen(
          loginArgs: state.extra as LoginArgs,
        );
      },
    ),
    GoRoute(
      path: "/:tab(home|search|message|mypage)",
      builder: (context, state) {
        final String tabName = state.params["tab"].toString();
        return MainNavScreen(
          tabName: tabName,
        );
      },
    ),
    GoRoute(
      path: ActivityScreen.route,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      path: DmScreen.route,
      builder: (context, state) => const DmScreen(),
      routes: [
        GoRoute(
          path: DmDetailScreen.route,
          name: DmDetailScreen.name,
          builder: (context, state) {
            final String id = state.params["chatId"].toString();
            return DmDetailScreen(
              chatId: id,
            );
          },
        ),
      ],
    ),

    GoRoute(
      path: VideoCreateScreen.route,
      name: VideoCreateScreen.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        transitionDuration: const Duration(milliseconds: 500),
        child: const VideoCreateScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final position = Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(animation);

          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    ),

    // GoRoute(
    //   path: VideoPreviewScreen.route,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     transitionDuration: const Duration(milliseconds: 200),
    //     child: VideoPreviewScreen(
    //       videoArgs: state.extra as VideoArgs,
    //     ),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       final position = Tween(begin: const Offset(0, 1), end: Offset.zero)
    //           .animate(animation);

    //       return SlideTransition(
    //         position: position,
    //         child: child,
    //       );
    //     },
    //   ),
    // ),

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
