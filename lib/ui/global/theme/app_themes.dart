import 'package:flutter/material.dart';

enum AppTheme { light, dark }

final appThemeData = {
  AppTheme.light: ThemeData(
    brightness: Brightness.light,
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[800],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.orange),
    ),
  )
};
