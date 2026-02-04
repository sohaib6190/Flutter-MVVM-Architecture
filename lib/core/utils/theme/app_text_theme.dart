part of 'theme.dart';

class AppTextTheme {
  AppTextTheme._internal({
    this.fontFamily = "Karla",
  }) : _baseTextStyle = TextStyle(
          fontFamily: fontFamily,
          fontWeight: AppFontWeight.regular,
          letterSpacing: -0.8,
          height: 1.2,
        );

  static final AppTextTheme _instance = AppTextTheme._internal();

  factory AppTextTheme() {
    return _instance;
  }

  final String fontFamily;
  final TextStyle _baseTextStyle;

  TextStyle get headingText => _baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: AppFontWeight.semiBold,
      );

  TextStyle get bodyText => _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: AppFontWeight.medium,
      );

  TextStyle get lightText => _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: AppFontWeight.regular,
      );
}
