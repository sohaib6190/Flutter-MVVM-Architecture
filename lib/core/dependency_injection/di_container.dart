import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:cache/cache.dart';
import 'package:general_repository/general_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

import '../../features/core/cart/cubit/cart_cubit.dart';
import '../../features/core/cart/repository/repository.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await _initCoreDependencies();
  await _initCartDependencies();
}

/// ------------------------
/// Core DEPENDENCIES
/// ------------------------

Future<void> _initCoreDependencies() async {
  // Register HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Register Cache Client
  sl.registerLazySingleton<CacheClient>(() => CacheClient());

  // Register General Repository
  sl.registerLazySingleton<GeneralRepository>(
    () => GeneralRepository(client: sl<http.Client>()),
  );

  // Register Authentication Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      sl<GeneralRepository>(),
      cache: sl<CacheClient>(),
    ),
  );

  // Initialize the circular dependency
  sl<GeneralRepository>().initialize(sl<AuthenticationRepository>());
}

/// ------------------------
/// Cart Dependencies
/// ------------------------

Future<void> _initCartDependencies() async {
  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(sl<GeneralRepository>()),
  );
  sl.registerFactory<CartCubit>(() => CartCubit(sl<CartRepository>()));
}
