import 'package:flutter/material.dart';
import 'package:rise/layout/home_screen_layout.dart';
import 'package:rise/modules/quick_note_screen.dart';
import 'package:rise/modules/splash_screen.dart';

void main() {
  runApp(const RiseApp());
}

class RiseApp extends StatelessWidget {
  const RiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'WinkyRough',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'WinkyRough'),
          bodyMedium: TextStyle(fontFamily: 'WinkyRough'),
          bodySmall: TextStyle(fontFamily: 'WinkyRough'),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'WinkyRough',
            color: Colors.white,
            fontSize: 14,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        useMaterial3: false,
      ),
      home: HomeScreenLayout(),
    );
  }
}
