import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cache/cache.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit(
    this.authenticationRepository, {
    CacheClient? cache,
  })  : cache = cache ?? CacheClient(),
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(
                  authenticationRepository.currentUser,
                  const Locale('en'),
                  true,
                  true,
            
                 )
              : const AppState.unauthenticated(Locale('en'), true, true),
        ) {
    userSubscription = authenticationRepository.user.listen(
      (user) => changeAppState(user),
    );
  }

  final AuthenticationRepository authenticationRepository;
  late final StreamSubscription<UserAuthentication> userSubscription;
  final CacheClient cache;

  void changeAppState(UserAuthentication user) {
    emit(
      user.isNotEmpty
          ? AppState.authenticated(
              user,
              state.locale,
              state.isDarkTheme,
              state.showOnboarding,
              )
          : AppState.unauthenticated(
              state.locale,
              state.isDarkTheme,
              state.showOnboarding,
             
            ),
    );
  }

  void initializeApp() {
    fcmService.initializeFcmService();

    final locale = cache.read<String>(key: AppKeys.localeCacheKey);
    final theme = cache.read<bool>(key: AppKeys.themeCacheKey);
  

    emit(state.copyWith(
      locale: locale == null ? const Locale('en') : Locale(locale),
      isDarkTheme: theme ?? true,
    
  
    ));
  }

  void selectEnglishLocale() {
    emit(state.copyWith(locale: const Locale('en')));
    cache.write<String>(key: AppKeys.localeCacheKey, value: 'en');
  }

  void changeTheme() {
    emit(state.copyWith(isDarkTheme: !state.isDarkTheme));
    cache.write<bool>(key: AppKeys.themeCacheKey, value: state.isDarkTheme);
  }



  void disableOnboarding() {
    emit(state.copyWith(showOnboarding: false));
    cache.write<bool>(key: AppKeys.onboardingCacheKey, value: false);
  }




  void deleteAccount() {

    unawaited(authenticationRepository.deleteAccount());
  }

  void logout() {

    authenticationRepository.logout();
  }

  @override
  Future<void> close() {
    userSubscription.cancel();
    authenticationRepository.dispose();
    return super.close();
  }
}
