part of 'di_barrel.dart';

final sl = GetIt.instance;

Future<void> initializeDI() async {
  await _initCoreDependencies();
  await _initRepositoryDependencies();
  await _initCartDependencies();
}

Future<void> _initCoreDependencies() async {
  // Initialize cache first
  await CacheClient.initializeCache();

  // Register cache client
  sl.registerLazySingleton<CacheClient>(() => CacheClient());

  // Register HTTP client
  sl.registerLazySingleton<http.Client>(() => http.Client());
}

Future<void> _initRepositoryDependencies() async {
  // Register General Repository first
  sl.registerLazySingleton<GeneralRepository>(
    () => GeneralRepository(client: sl<http.Client>()),
  );

  // Register Authentication Repository
  sl.registerLazySingleton<AuthenticationRepository>(() {
    final authRepo = AuthenticationRepository(
      sl<GeneralRepository>(),
      cache: sl<CacheClient>(),
    );
    // Initialize the general repository with auth repository
    sl<GeneralRepository>().initialize(authRepo);
    return authRepo;
  });
}

Future<void> _initCartDependencies() async {
  // Register feature repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(sl<GeneralRepository>()),
  );

  // Register Cubits/Blocs
  // Note: These are registered as factories so each widget gets a new instance
  sl.registerFactory<CartCubit>(() => CartCubit(sl<CartRepository>()));
}

// /// Dispose all registered dependencies
// /// Call this when the app is disposed
// Future<void> disposeDI() async {
//   await sl.reset();
// }

