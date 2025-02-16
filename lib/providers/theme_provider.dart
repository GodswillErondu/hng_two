import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Color get borderColor => _isDarkMode ? Color(0xFFA9B8D4)! : Colors.grey[300]!;

  ThemeData getTheme() {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000f24),
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.0,
          color: Color(0xFF000f24),
          titleTextStyle: TextStyle(
            fontFamily: 'Axiforma',
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: Color(0xFFEAECF0),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFF2F4F7),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xFF1E2C41),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00FFFFFF),
              foregroundColor: Color(0xFFF2F4F7),
              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Color(0xFFF2F4F7)))),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w500,
              fontSize: 12.0),
          bodyMedium: TextStyle(
              color: Color(0xFFF2F4F7),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
          bodySmall: TextStyle(
              color: Color(0xFF98A2B3),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
        ),
      );

  ThemeData get _lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.0,
          color: Color(0xFFFFFFFF),
          titleTextStyle: TextStyle(
            fontFamily: 'Axiforma',
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
            color: Color(0xFF1C1917),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF1C1917),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0xFFF2F4F7),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFFF),
              foregroundColor: Color(0xFF1C1917),
              shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Color(0xFF1C1917)))),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w500,
              fontSize: 12.0),
          bodyMedium: TextStyle(
              color: Color(0xFF1C1917),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
          bodySmall: TextStyle(
              color: Color(0xFF667085),
              fontFamily: 'Axiforma',
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
        ),
      );
}
