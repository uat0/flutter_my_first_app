import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF5F5F5); // PageBackgroundColor
  static const primary = Color(0xFF4CAF50); // PrimaryColor
  static const surface = Color(0xFFFFFFFF); // InterfaceColor
  static const error = Color(0xFFFF5252); // ErrorTextColor
  static const textSecondary = Color(0xFF757575); // SecondaryTextColor
  static const text = Color(0xFF212121); // PrimaryTextColor

  static const divider = Color(0xFFBDBDBD); // линия под полем ввода
  static const resultBackground = Color(0xFFE8F5E9); // фон блока результата
}

const double kCardRadius = 10;
const double kButtonRadius = 8;
const double kMaxContentWidth = 420;

const List<BoxShadow> kCardShadow = [
  BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 2)),
];

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      error: AppColors.error,
      surface: AppColors.surface,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      contentPadding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.divider)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.7),
        disabledForegroundColor: Colors.white,
        minimumSize: const Size.fromHeight(46),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    ),
  );
}