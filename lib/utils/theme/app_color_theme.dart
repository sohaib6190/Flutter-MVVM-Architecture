part of 'theme.dart';

class AppColorTheme {
  // Private constructor
  AppColorTheme._internal();

  // The single instance
  static final AppColorTheme _instance = AppColorTheme._internal();

  // Factory constructor to return the same instance
  factory AppColorTheme() {
    return _instance;
  }

  // Color definitions
  Color get primary => const Color(0xFF56B9F2);
  Color get secondary => const Color(0xFF35363A);
  Color get darkBackground => const Color(0xFF0E0E0E);
  Color get lightBackground => const Color(0xFFF0F0F0);
  Color get black => const Color(0xFF000000);
  Color get black20 => const Color(0xFF202020);
  Color get black40 => const Color(0xFF22272B);
  Color get white => const Color(0xFFFFFFFF);
  Color get lightGrey => const Color(0xFFD9D9D9);
  Color get lightGrey50 => const Color(0xffA4A6B0);
  Color get lightGrey80 => const Color(0xFFE2E3E6);
  Color get lightGrey70 => const Color(0xFFE5E5E5);
  Color get lightGrey60 => const Color(0xFFF1F1F1);
  Color get lightGrey90 => const Color(0xFF6F6D6D);
  Color get customBlue => const Color(0xFF004999);

  Color get yellow => const Color(0xFFF2C94C);
  Color get red => const Color(0xFFFF0000);
  Color get green => const Color(0xFF4BB543);
  Color get berryline => const Color(0xFF00EFEB);
  Color get purple => const Color(0xFFA020F0);
  Color get blue => const Color.fromARGB(255, 25, 162, 241);
  Color get lightBlue => const Color(0xFF56B9F2);
  Color get darkBlue => const Color(0xFF004999);
  Color get darkBrown => const Color.fromARGB(166, 78, 41, 30);
  Color get greyshade1 => const Color.fromARGB(255, 67, 68, 73);
  Color get greyshade2 => const Color(0xFF696969);
  Color get darkGrey => const Color.fromARGB(255, 32, 33, 36);
  Color get orange => const Color(0xffFF6801);
  Color get lightShimmerBaseColor => Colors.grey[300]!;
  Color get lightShimmerHighlightColor => Colors.grey[100]!;
  Color get darkShimmerBaseColor => Colors.grey[800]!;
  Color get darkShimmerHighlightColor => Colors.grey[600]!;
  Color get primaryGradient1 => const Color(0xFF004999);
  Color get primaryGradient2 => const Color(0xFF00EFEB);
  // black shade
  Color get blackShade2 => const Color(0x0D0D0D1A);

  // Gradient definition
  LinearGradient get primaryGradient => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          primaryGradient1,
          primaryGradient2,
        ],
      );
}
