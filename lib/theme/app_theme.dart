/// Se define los diferentes temas que puede tener la App
/// lightTheme
/// darkTheme

import 'package:flutter/material.dart';

class AppTheme {
  // Define el color primario para todo el sistema
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueGrey;
  static const Color cancel = Color.fromARGB(255, 157, 170, 177);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color danger = Colors.red;

/* ******* Configura el tema claro para la app **********************/
  static ThemeData lightTheme = ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
          elevation: 10,
          foregroundColor: white,
          backgroundColor: primaryColor,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),

      // text Button Theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: white)),

      //Floating Actions Buttons
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),

      // Elevated Buttoms theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: const StadiumBorder(),
            elevation: 0),
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

      // Dropdown Decoration Theme
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      )));

/* ******* Configura el tema oscuro para la app **********************/
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.indigoAccent,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
      ),
      scaffoldBackgroundColor: Colors.black);
}
