import 'package:flutter_clean_architecture/features/cart/view/view.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth.dart';
import '../../features/cart/data/model/request/cart_add_params.dart';
import '../../features/root/root.dart';
import '../components/generic_widgets/connectivity_overlay.dart';
import '../observers/navigator_observer.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.cartListing}',
  observers: [UnFocusOnNavigateObserver()],
  routes: [
    /// ====================== Auth Routes ======================
    ...authRoutes,

    /// ====================== Core Routes ======================
    ShellRoute(
      builder: (context, GoRouterState state, child) {
        return ConnectivityOverlay(child: child);
      },
      routes: [
        _root(),
        ...cartRoutes
      ],
    ),
  ],
);

List<GoRoute> authRoutes = [
  _login(),
  _forgotPasswordEmail(),
  _forgotPasswordOtp(),
  _forgotPasswordNewPass(),
];

List<GoRoute> cartRoutes = [_cartListing(), _addCart()];

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

GoRoute _cartListing() {
  return GoRoute(
    path: '/${AppRoutes.cartListing}',
    name: AppRoutes.cartListing,
    builder: (context, state) {
      return CartListingView();
    },
  );
}

GoRoute _addCart() {
  return GoRoute(
    path: '/${AppRoutes.addCart}',
    name: AppRoutes.addCart,
    builder: (context, state) {
      final cartAddParams = state.extra as CartAddParams;
      return CartPostView(cartAddParams: cartAddParams);
    },
  );
}

GoRoute _root() {
  return GoRoute(
    path: '/${AppRoutes.home}',
    name: AppRoutes.home,
    builder: (context, state) => const RootPage(),
  );
}
