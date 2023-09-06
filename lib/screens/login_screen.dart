import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class InputsScreen extends StatelessWidget {
  const InputsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, String> frmValues = {
      'user': 'jperez',
      'password': '12345',
    };

    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: myFormKey,
              child: Column(
                children: [
                  InputsWidget(
                    labelText: 'User',
                    icon: Icons.group_rounded,
                    minLength: 5,
                    property: 'user',
                    frmValues: frmValues,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputsWidget(
                    labelText: 'Password',
                    minLength: 5,
                    obscureText: true,
                    icon: Icons.lock,
                    property: 'password',
                    frmValues: frmValues,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Boton Save
                  ElevatedButton(
                      onPressed: () {
                        // Para ocultar el teclado
                        FocusScope.of(context).requestFocus(FocusNode());

                        // Validar que el formulario no tenga campos vacios al dar click en el boton guardar
                        if (!myFormKey.currentState!.validate()) {
                          // print('Frm no valido');
                          return;
                        } else if (frmValues['user'] == 'jperez' &&
                            frmValues['password'] == '12345') {
                          // Impimir valores del form si no hay errores
                          // print(frmValues);
                          Navigator.pushNamed(context, 'welcome');
                        } else {
                          showDialog(
                              barrierDismissible:
                                  false, // Permite cerrar el modal cuando se hace clikc afuera
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  title: const Text(
                                    'Error',
                                    textAlign: TextAlign.center,
                                  ), // Titulo de la card
                                  content: const Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // Ajusta la card al texto mas pequenho
                                    children: [
                                      Text('Usuario o contraseña inválidos'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Ok'))
                                  ],
                                );
                              });
                        }
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text('Login'),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
