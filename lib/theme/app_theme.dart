import 'package:flutter/material.dart';

class AppTheme {
  // Define el color primario para todo el sistema
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueGrey;
  static const Color white = Colors.white;
  static const Color black = Colors.black;

/* ******* Configura el tema claro para la app **********************/
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),

    // text Button Theme
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor)),

    //Floating Actions Buttons
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),

    // Elevated Buttoms theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: const StadiumBorder(),
          elevation: 1),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: primaryColor),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

/* ******* Configura el tema oscuro para la app **********************/
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.indigoAccent,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
      ),
      scaffoldBackgroundColor: Colors.black);
}
