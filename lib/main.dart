import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:general_repository/general_repository.dart';

import 'core/app/view/app.dart';
import 'core/dependency_injection/di_barrel.dart';
import 'core/utils/constants/constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await initializeDI();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 500;

  AppApis().initBaseUrlAndAuthEndpoints();

  // Get repositories from service locator
  final authenticationRepository = sl<AuthenticationRepository>();
  await authenticationRepository.user.first;

  runApp(
    App(
      authenticationRepository: authenticationRepository,
      generalRepository: sl<GeneralRepository>(),
    ),
  );
}
