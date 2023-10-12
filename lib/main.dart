import 'package:flutter/material.dart';
import 'package:login_flutter/routes/app_routes.dart';
import 'package:login_flutter/theme/app_theme.dart';

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
        routes: AppRoutes.getAppRoutes(),
        theme: AppTheme.lightTheme

        // ThemeData(
        //   primaryColor: AppTheme.primaryColor,
        //   appBarTheme: AppBarTheme(
        //     color: AppTheme.primaryColor,
        //     elevation: 0,
        //   ),
        //   textButtonTheme: TextButtonThemeData(
        //     style: TextButton.styleFrom(
        //       foregroundColor: AppTheme.primaryColor,
        //     ),
        //   ),
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: AppTheme.primaryColor,
        //       shape: const StadiumBorder(),
        //       elevation: 0,
        //     ),
        //   ),
        //   inputDecorationTheme: InputDecorationTheme(
        //     floatingLabelStyle: TextStyle(color: AppTheme.primaryColor),
        //     prefixIconColor: AppTheme.primaryColor,
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(color: AppTheme.primaryColor),
        //     ),
        //   ),
        // ),
        );
  }
}
