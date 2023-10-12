import 'package:flutter/material.dart';

class AppTheme {
  // Define el color primario para todo el sistema
  static Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueGrey;
  static const Color cancel = Color.fromARGB(255, 157, 170, 177);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color danger = Colors.red;

/* ******* Configura el tema claro para la app **********************/
  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: Colors.red,
      appBarTheme: AppBarTheme(
        color: AppTheme.primaryColor,
        elevation: 1,
        foregroundColor: AppTheme.primaryColor,
        // backgroundColor: AppTheme.primaryColor,
      ),

      // text Button Theme
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryColor)),

      //Floating Actions Buttons
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),

      // Elevated Buttoms theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            shape: const StadiumBorder(),
            elevation: 1),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelStyle: TextStyle(color: primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
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
      appBarTheme: AppBarTheme(
        color: primaryColor,
      ),
      scaffoldBackgroundColor: Colors.black);
}
