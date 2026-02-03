part of 'constants.dart';

class AppKeys {
  AppKeys._internal();

  static final AppKeys _instance = AppKeys._internal();

  factory AppKeys() {
    return _instance;
  }

  static const String userCacheKey = '__user_cache_key__';
  static const String localeCacheKey = '__locale_cache_key__';
  static const String onboardingCacheKey = '__onboarding_cache_key__';
  static const String themeCacheKey = '__theme_cache_key__';

}
