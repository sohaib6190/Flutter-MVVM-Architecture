part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await _initCoreDependencies();
  await _initRepositoryDependencies();
  await _initCartDependencies();
}

Future<void> _initCoreDependencies() async {
  await CacheClient.initializeCache();

  sl.registerLazySingleton<CacheClient>(() => CacheClient());

  sl.registerLazySingleton<http.Client>(() => http.Client());
}

Future<void> _initRepositoryDependencies() async {
  sl.registerLazySingleton<GeneralRepository>(
    () => GeneralRepository(client: sl<http.Client>()),
  );

  sl.registerLazySingleton<AuthenticationRepository>(() {
    final authRepo = AuthenticationRepository(
      sl<GeneralRepository>(),
      cache: sl<CacheClient>(),
    );

    sl<GeneralRepository>().initialize(authRepo);
    return authRepo;
  });
}

Future<void> _initCartDependencies() async {
  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(sl<GeneralRepository>()),
  );

  sl.registerFactory<CartCubit>(() => CartCubit(sl<CartRepository>()));
}
