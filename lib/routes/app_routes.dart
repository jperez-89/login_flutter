import 'package:flutter/material.dart';
import 'package:login_flutter/models/menu_option.dart';
import '../screens/screen.dart';

class AppRoutes {
  static const initialRoute = 'inputs';

// Crear un listado de menu
  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'inputs',
        icon: Icons.input_outlined,
        nameRoute: 'Inputs',
        screen: const InputsScreen()),
    MenuOption(
        route: 'welcome',
        icon: Icons.play_circle_fill_outlined,
        nameRoute: 'Welcome',
        screen: const WelcomeScreen()),
  ];

// Definiendo rutas de manera dinamica
  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes
        .addAll({'inputs': (BuildContext context) => const InputsScreen()});

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }
    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const InputsScreen());
  }
}
