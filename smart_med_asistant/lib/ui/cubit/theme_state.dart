import 'package:flutter/material.dart';

class ThemeState {
  final ThemeData themeData;
  final bool isDark;

  ThemeState({required this.themeData, required this.isDark});

  factory ThemeState.light() => ThemeState(
    themeData: ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.green,
      useMaterial3: true,
    ),
    isDark: false,
  );

  factory ThemeState.dark() => ThemeState(
    themeData: ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.green,
      useMaterial3: true,
    ),
    isDark: true,
  );
}
