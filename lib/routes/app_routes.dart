import 'package:flutter/material.dart';
import 'package:login_flutter/models/menu_option.dart';
import 'package:login_flutter/screens/screen.dart';

class AppRoutes {
  static const initialRoute = 'dashboard';

// Crear un listado de menu
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'login',
        icon: Icons.input_outlined,
        nameRoute: 'Login',
        screen: const LoginScreen()),
    MenuOption(
        route: 'welcome',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'Welcome',
        screen: const WelcomeScreen()),
    MenuOption(
        route: 'dashboard',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'Pega Dashboard',
        screen: const DashboardPegaScreen()),
    MenuOption(
        route: 'Interprete',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'New Interpreter Asignment',
        screen: const NewInterpreterAsignment()),
    MenuOption(
        route: 'RentalCar',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'New Rent Car Asignment',
        screen: const NewRentCarAsignment()),
    MenuOption(
        route: 'NewCase',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'NewCase',
        screen: const NewInterpreterAsignment()),
  ];

// Definiendo rutas de manera dinamica
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'login': (BuildContext context) => const LoginScreen()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
