part of 'constants.dart';

class AppImages {
  AppImages._internal();

  static final AppImages _instance = AppImages._internal();

  factory AppImages() {
    return _instance;
  }

  static const String logo = 'assets/images/logo.png';

}
