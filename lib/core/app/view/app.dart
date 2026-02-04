import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:general_repository/general_repository.dart';

import '../../../features/auth/cubit/auth_cubit.dart';
import '../../../features/core/cart/cubit/cart_cubit.dart';
import '../../../features/core/cart/view/view.dart';
import '../../custom_widgets/generic_widgets/connectivity_overlay.dart';
import '../../dependency_injection/di_container.dart';
import '../../utils/utils.dart';
import '../app.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authenticationRepository,
    required this.generalRepository,
  });

  final AuthenticationRepository authenticationRepository;
  final GeneralRepository generalRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: generalRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppCubit(authenticationRepository)..initializeApp(),
          ),
          BlocProvider(
            create: (context) => AuthCubit(authenticationRepository),
          ),
          BlocProvider(create: (context) => sl<CartCubit>()),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  StreamSubscription<bool>? _sessionExpiredSubscription;

  @override
  void initState() {
    super.initState();
    // _listenToSessionExpired();
  }

  // void _listenToSessionExpired() {
  //   _sessionExpiredSubscription = context
  //       .read<GeneralRepository>()
  //       .sessionExpired
  //       .listen((expired) {
  //         if (expired && mounted) {
  //           _showSessionExpiredDialog();
  //         }
  //       });
  // }

  // void _showSessionExpiredDialog() {

  //   showDialog(
  //     context: navigatorKey.currentContext!,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => SessionExpiredDialog(
  //       onLoginTap: () {

  //         Navigator.of(dialogContext).pop();

  //         navigatorKey.currentState?.pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (context) => const AuthPage(),
  //           ),
  //           (route) => false,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _sessionExpiredSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dummy App",
      navigatorKey: navigatorKey,
      theme: AppTheme().lightThemeData,
      locale: context.locale,

      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.0), boldText: false),
        child: ConnectivityOverlay(child: child!),
      ),
      home: _buildPages(context),
    );
  }

  Widget _buildPages(BuildContext context) {
    return CartListingView();
  }
}
