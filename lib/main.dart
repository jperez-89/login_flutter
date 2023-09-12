import 'package:flutter/material.dart';
import 'package:login_flutter/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color primaryColor = Colors.blue;
  static const Color appBarColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        initialRoute: AppRoutes.initialRoute,
        // Se envian los parametros de rutas
        routes: AppRoutes
            .getAppRoutes(), // Se optienen las rutas por elmetodo dinamico
        theme: ThemeData(
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: primaryColor,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: const StadiumBorder(),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelStyle: TextStyle(color: primaryColor),
            prefixIconColor: primaryColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ));
  }
}
