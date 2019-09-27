import 'package:flutter/material.dart';

String dark = 'dark';
String light = 'light';

String themseMode = dark;

class DarkMode {
  static Color primaryColor = Color(0xff121212);
  static Color secondColor = Color(0xff212121);

  static int primaryHexColor = 0xff121212;
  static int secondHexHexColor = 0xff212121;
}

class LightMode {
  static Color primaryColor = Color(0xffffffff);
  static Color secondColor = Color(0xff212121);

  static int primaryHexColor = 0xffffffff;
  static int secondHexHexColor = 0xff212121;
}

class ThemseColors {
  static Color primaryColor =
      themseMode == dark ? DarkMode.primaryColor : LightMode.primaryColor;
  static Color secondColor =
      themseMode == dark ? DarkMode.secondColor : LightMode.secondColor;
}

class ThemseHexColors {
  static int primaryColor =
      themseMode == dark ? DarkMode.primaryHexColor : LightMode.primaryHexColor;

  static int secondColor = themseMode == dark
      ? DarkMode.secondHexHexColor
      : LightMode.secondHexHexColor;
}
