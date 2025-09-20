import 'package:flutter/material.dart';

import '../utils.dart';

part 'app_color_theme.dart';
part 'app_icons.dart';
part 'app_text_theme.dart';

class AppTheme {
  AppTheme._internal({
    AppColorTheme? appColorTheme,
    AppTextTheme? appTextTheme,
  })  : _aerialColorTheme = appColorTheme ?? AppColorTheme(),
        _aerialTextTheme = appTextTheme ?? AppTextTheme();

  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  final AppColorTheme _aerialColorTheme;
  final AppTextTheme _aerialTextTheme;

  ThemeData get darkThemeData => ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
        primaryColor: _aerialColorTheme.primary,
        fontFamily: _aerialTextTheme.fontFamily,
        inputDecorationTheme: inputDecorationThemeData,
        iconTheme: iconThemeData,
        listTileTheme: listTileThemeData,
        appBarTheme: appBarTheme,
        scaffoldBackgroundColor: _aerialColorTheme.darkBackground,
        elevatedButtonTheme: elevatedButtonThemeData,
        outlinedButtonTheme: outlinedButtonThemeData,
        dividerTheme: darkDividerTheme,
        datePickerTheme: darkDatePickerTheme,
      );

  ThemeData get lightThemeData => ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
        primaryColor: _aerialColorTheme.primary,
        fontFamily: _aerialTextTheme.fontFamily,
        inputDecorationTheme: inputDecorationThemeData,
        iconTheme: iconThemeData,
        listTileTheme: listTileThemeData,
        appBarTheme: appBarTheme,
        scaffoldBackgroundColor: _aerialColorTheme.lightBackground,
        elevatedButtonTheme: elevatedButtonThemeData,
        outlinedButtonTheme: outlinedButtonThemeData,
        dividerTheme: lightDividerTheme,
        datePickerTheme: lightDatePickerTheme,
      );

  ColorScheme get lightColorScheme => const ColorScheme.light().copyWith(
        primary: _aerialColorTheme.primary,
        secondary: _aerialColorTheme.secondary,
        surfaceTint: Colors.transparent,
      );

  ColorScheme get darkColorScheme => const ColorScheme.dark().copyWith(
        primary: _aerialColorTheme.primary,
        secondary: _aerialColorTheme.secondary,
        surfaceTint: Colors.transparent,
      );

  IconThemeData get iconThemeData => IconThemeData(
        color: _aerialColorTheme.primary,
      );

  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      );

  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      );

  ListTileThemeData get listTileThemeData => ListTileThemeData(
        iconColor: _aerialColorTheme.primary,
      );

  InputDecorationTheme get inputDecorationThemeData => InputDecorationTheme(
        iconColor: _aerialColorTheme.primary,
        hintStyle: TextStyle(
          fontFamily: "Karla",
          fontSize: 18,
          fontWeight: AppFontWeight.medium,
          letterSpacing: -0.8,
          height: 1.2,
          color: _aerialColorTheme.secondary,
        ),
        labelStyle: TextStyle(
          fontFamily: "Karla",
          fontSize: 18,
          fontWeight: AppFontWeight.medium,
          letterSpacing: -0.8,
          height: 1.2,
          color: _aerialColorTheme.secondary,
        ),
      );

  AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _aerialColorTheme.primary,
        elevation: 0,
      );

  DividerThemeData get lightDividerTheme => DividerThemeData(
        color: _aerialColorTheme.lightGrey,
        space: 0,
        thickness: 1,
      );

  DividerThemeData get darkDividerTheme => DividerThemeData(
        color: _aerialColorTheme.lightGrey.withValues(alpha: 0.3),
        space: 0,
        thickness: 1,
      );

  DatePickerThemeData get darkDatePickerTheme => DatePickerThemeData(
        backgroundColor: _aerialColorTheme.secondary,
      );

  DatePickerThemeData get lightDatePickerTheme => DatePickerThemeData(
        backgroundColor: _aerialColorTheme.lightBackground,
      );
}
