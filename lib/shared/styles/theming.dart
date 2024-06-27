import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/colors.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: mintGreen,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.shifting,
      backgroundColor: Colors.transparent,
      selectedItemColor: blueColor,
      unselectedItemColor: Colors.grey,
    ),
  );
  static ThemeData darkTheme = ThemeData();
}
