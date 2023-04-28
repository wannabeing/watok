import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:watok/common/widgets/navigations/main_nav_screen.dart';
import 'package:watok/features/authentication/login_screen.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/authentication/sign_up_screen.dart';
import 'package:watok/features/message/activity_screen.dart';
import 'package:watok/features/message/dm_detail_screen.dart';
import 'package:watok/features/message/dm_screen.dart';
import 'package:watok/features/onboard/interests_screen.dart';

import 'features/videos/views/video_create_screen.dart';

final goRouterProvider = Provider((ref) {
  // ref.watch(authStream); 로그인 여부를 실시간 감지하여 redirect.
  return GoRouter(
    initialLocation: MainNavScreen.route,
    redirect: (context, state) {
      final isLogin = ref.watch(authRepository).isLogin;
      // 로그인을 안했고, 현 페이지가 회원가입/로그인페이지가 아닐 때
      if (!isLogin) {
        if (state.subloc != SignUpScreen.route &&
            state.subloc != LoginScreen.route) {
          return SignUpScreen.route;
        }
      }
      return null;
    },
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
});
