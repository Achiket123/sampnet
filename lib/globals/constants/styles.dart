import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

TextTheme textTheme = const TextTheme(
    titleLarge: TextStyle(
      color: ColorPallete.textPrimary,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: ColorPallete.textPrimary,
      fontSize: 50,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: ColorPallete.textPrimary,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
        color: ColorPallete.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(
        color: ColorPallete.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(
        color: ColorPallete.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(
        color: ColorPallete.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
    bodySmall: TextStyle(color: ColorPallete.textSecondary, fontSize: 9));

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    fillColor: ColorPallete.backgroundTertiary,
    filled: true,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 1.0,
          color: ColorPallete.divider,
        )),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 2.0,
          color: ColorPallete.redPrimary,
        )),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 1.0,
          color: ColorPallete.redPrimary,
        )),
    labelStyle: const TextStyle(color: ColorPallete.textSecondary),
    hintStyle: const TextStyle(color: ColorPallete.textDisabled),
    prefixIconColor: ColorPallete.textSecondary,
    suffixIconColor: ColorPallete.textSecondary,
);
