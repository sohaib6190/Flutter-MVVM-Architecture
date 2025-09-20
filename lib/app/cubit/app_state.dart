part of 'app_cubit.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = UserAuthentication.empty,
    this.locale = const Locale('en'),
    this.isDarkTheme = true,
    this.showOnboarding = true,
  

  });

  const AppState.authenticated(
      UserAuthentication user,
      Locale locale,
      bool isDarkTheme,
     
      bool showOnboarding,

      )
      : this._(
          status: AppStatus.authenticated,
          user: user,
          locale: locale,
          isDarkTheme: isDarkTheme,
       
          showOnboarding: showOnboarding,
        
        );

  const AppState.unauthenticated(
      Locale locale,
      bool isDarkTheme,
   
      bool showOnboarding,
    )
      : this._(
          status: AppStatus.unauthenticated,
          locale: locale,
          isDarkTheme: isDarkTheme,
          showOnboarding: showOnboarding,
        
        );

  bool get isAuthenticated => status == AppStatus.authenticated;

  final AppStatus status;
  final UserAuthentication user;
  final Locale locale;
  final bool isDarkTheme;
  final bool showOnboarding;


  AppState copyWith({
    AppStatus? status,
    UserAuthentication? user,
    Locale? locale,
    bool? isDarkTheme,
    bool? showOnboarding,
   
  
  }) =>
      AppState._(
        status: status ?? this.status,
        user: user ?? this.user,
        locale: locale ?? this.locale,
        isDarkTheme: isDarkTheme ?? this.isDarkTheme,
        showOnboarding: showOnboarding ?? this.showOnboarding,
   
      );

  @override
  List<Object?> get props => [
        status,
        user,
        locale,
        isDarkTheme,
        showOnboarding,
   
      ];
}
