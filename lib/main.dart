import 'package:flutter/material.dart';
import 'package:login_flutter/routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          primaryColor: Colors.teal[400],
          appBarTheme: const AppBarTheme(
            color: Colors.teal,
            elevation: 0,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Colors.teal),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: const StadiumBorder(),
                elevation: 0),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelStyle: TextStyle(color: Colors.teal),
            prefixIconColor: Colors.teal,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
        ));
  }
}
