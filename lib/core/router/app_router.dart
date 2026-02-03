import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/root/root.dart';
import '../custom_widgets/generic_widgets/connectivity_overlay.dart';
import '../observers/navigator_observer.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.login}',
  observers: [UnFocusOnNavigateObserver()],
  routes: [
    /// ====================== Auth Routes ======================
    ...authRoutes,

    /// ====================== Core Routes ======================
    ShellRoute(
      builder: (context, GoRouterState state, child) {
        return ConnectivityOverlay(child: child);
      },
      routes: [_home()],
    ),
  ],
);

List<GoRoute> authRoutes = [
  _login(),
  _forgotPasswordEmail(),
  _forgotPasswordOtp(),
  _forgotPasswordNewPass(),
];

GoRoute _login() {
  return GoRoute(
    path: '/${AppRoutes.login}',
    name: AppRoutes.login,
    builder: (context, state) => const AuthPage(),
  );
}

GoRoute _forgotPasswordEmail() {
  return GoRoute(
    path: '/${AppRoutes.forgotPasswordEmail}',
    name: AppRoutes.forgotPasswordEmail,
    builder: (context, state) {
      final cubit = state.extra as dynamic;
      return ForgotPasswordEmailPage(cubit: cubit);
    },
  );
}

GoRoute _forgotPasswordOtp() {
  return GoRoute(
    path: '/${AppRoutes.forgotPasswordOtp}',
    name: AppRoutes.forgotPasswordOtp,
    builder: (context, state) {
      final cubit = state.extra as dynamic;
      return ForgotPasswordOtpPage(cubit: cubit);
    },
  );
}

GoRoute _forgotPasswordNewPass() {
  return GoRoute(
    path: '/${AppRoutes.forgotPasswordNewPass}',
    name: AppRoutes.forgotPasswordNewPass,
    builder: (context, state) {
      final cubit = state.extra as dynamic;
      return ForgotPasswordNewPassPage(cubit: cubit);
    },
  );
}

GoRoute _home() {
  return GoRoute(
    path: '/${AppRoutes.home}',
    name: AppRoutes.home,
    builder: (context, state) => const RootPage(),
  );
}
