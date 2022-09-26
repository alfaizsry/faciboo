import 'package:flutter/material.dart';

enum MyTheme { light, dark }

class ThemeNotifier with ChangeNotifier {
  static List<ThemeData> themes = [
    ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green[400],
      backgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.green[400],
        elevation: 0,
      ),
      fontFamily: 'Poppins',
    ),
    ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green[600],
      fontFamily: 'Poppins',
    )
  ];

  MyTheme _current = MyTheme.light;
  ThemeData _currentTheme = themes[0];

  void switchTheme() =>
      currentTheme == MyTheme.light ? currentTheme = MyTheme.dark : currentTheme = MyTheme.light;

  set currentTheme(theme) {
    if (theme != null) {
      _current = theme;
      _currentTheme = _current == MyTheme.light ? themes[0] : themes[1];

      notifyListeners();
    }
  }

  get currentTheme => _current;
  get currentThemeData => _currentTheme;
}