part of 'constants.dart';

class AppApis {
  AppApis._internal();

  static final AppApis _instance = AppApis._internal();

  factory AppApis() {
    return _instance;
  }

  /// Local
  static const String baseUrl = "";

  /// Staging
  // static const String baseUrl = "";

  /// Production
  // static const String baseUrl = "";

  static const String baseApiUrl = "$baseUrl/api/";
  static const String login = 'login';
  static const String register = 'register';
  static const String updateProfile = 'profile';
  static const String changePassword = 'change-password';
  static const String forgotPassword = 'forgot-password';
  static const String verifyOtp = 'verify-otp';
  static const String resetPassword = 'reset-password';
  static const String logout = 'logout';
  static const String deleteAccount = 'user/delete-my-account';


  initBaseUrlAndAuthEndpoints() {
    ApiConfig.baseUrl = baseApiUrl;
    AuthenticationEndpoints.login = login;
    AuthenticationEndpoints.register = register;
    AuthenticationEndpoints.updateProfile = updateProfile;
    AuthenticationEndpoints.changePassword = changePassword;
    AuthenticationEndpoints.forgotPassword = forgotPassword;
    AuthenticationEndpoints.verifyOtp = verifyOtp;
    AuthenticationEndpoints.resetPassword = resetPassword;
    AuthenticationEndpoints.deleteAccount = deleteAccount;
    AuthenticationEndpoints.logout = logout;
  }
}
