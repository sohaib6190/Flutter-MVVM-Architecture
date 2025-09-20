import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:general_repository/general_repository.dart';

import 'app/app.dart';
import 'utils/utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: firebaseOptions);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: firebaseOptions);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await CacheClient.initializeCache();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 500;

  AppApis().initBaseUrlAndAuthEndpoints();

  final generalRepository = GeneralRepository();
  final authenticationRepository = AuthenticationRepository(generalRepository);
  await authenticationRepository.user.first;
  generalRepository.initialize(authenticationRepository);

  runApp(App(
    authenticationRepository: authenticationRepository,
    generalRepository: generalRepository,
  ));
}
