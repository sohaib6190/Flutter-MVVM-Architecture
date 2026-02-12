part of 'generics.dart';

extension PagePaddingExtension on BuildContext {
  
  EdgeInsets pagePadding({double horizontal = 20, double vertical = 20}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}



extension NavigationExtension on BuildContext {
  void pushPage(Widget page, {Function()? then}) {
    Navigator.of(this)
        .push(
      MaterialPageRoute(builder: (context) => page),
    )
        .then((_) {
      if (then != null) {
        then();
      }
    });
  }

  void pushReplacementPage(Widget page, {Function()? then}) {
    Navigator.of(this)
        .pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    )
        .then((_) {
      if (then != null) {
        then();
      }
    });
  }

  void pushAndRemoveUntilPage(Widget page, {Function()? then}) {
    Navigator.of(this)
        .pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    )
        .then((_) {
      if (then != null) {
        then();
      }
    });
  }

  void popUntilPage() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }

  void popPage<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}

extension BuildContextUtils on BuildContext {
  bool get isDarkTheme {
    return watch<AppCubit>().state.isDarkTheme;
  }



  bool get showOnboarding {
    return watch<AppCubit>().state.showOnboarding;
  }

  bool get isAuthenticated {
    return watch<AppCubit>().state.isAuthenticated;
  }

  Locale get locale {
    return watch<AppCubit>().state.locale;
  }



  Color get monochromeColor {
    return isDarkTheme ? AppColorTheme().white : AppColorTheme().black;
  }

  Color get shimmerBaseColor {
    return isDarkTheme
        ? AppColorTheme().darkShimmerBaseColor
        : AppColorTheme().lightShimmerBaseColor;
  }

  Color get shimmerHighlightColor {
    return isDarkTheme
        ? AppColorTheme().darkShimmerHighlightColor
        : AppColorTheme().lightShimmerHighlightColor;
  }

  TextStyle get headingText =>
      AppTextTheme().headingText.copyWith(color: monochromeColor);

  TextStyle get bodyText =>
      AppTextTheme().bodyText.copyWith(color: monochromeColor);

  TextStyle get lightText =>
      AppTextTheme().lightText.copyWith(color: monochromeColor);
}

extension MediaQueryValues on BuildContext {
  double get mWidth => MediaQuery.of(this).size.width;
  double get mHeight => MediaQuery.of(this).size.height;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String timeAgo() {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(this).toLocal();
    Duration diff = now.difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else {
      return '${(diff.inDays / 365).floor()}y ago';
    }
  }
}
// extension SizedBoxExtension on num {
//   SizedBox get verticalSpace => SizedBox(height: toDouble());
//   SizedBox get horizontalSpace => SizedBox(width: toDouble());
// }

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message,
      {Duration duration = const Duration(seconds: 3),
      Color? backgroundColor,
      TextStyle? textStyle}) {
    final bgColor = backgroundColor ?? AppColorTheme().primary;
    final txtStyle = textStyle ??
        AppTextTheme().lightText.copyWith(color: AppColorTheme().white);

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          content: Text(message, style: txtStyle),
          duration: duration,
        ),
      );
  }
}

extension AppFontWeight on FontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}
