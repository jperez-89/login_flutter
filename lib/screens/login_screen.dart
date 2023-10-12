import 'package:flutter/material.dart';
import 'package:login_flutter/models/actions/user_actions.dart';
import 'package:login_flutter/models/services/endpoints.dart';
import 'package:login_flutter/widgets/custom_inputs.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
    final Map<String, String> frmValues = {};

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Login')),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Form(
              key: myFormKey,
              child: Column(
                children: [
                  CustomInputs(
                    labelText: 'User',
                    icon: Icons.group_rounded,
                    minLength: 5,
                    property: 'user',
                    frmValues: frmValues,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomInputs(
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
                          return;
                        } else if (frmValues['user'] == '' &&
                            frmValues['password'] == '') {
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
                                      Text('Comlete todos los campos'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Ok'))
                                  ],
                                );
                              });
                        } else {
                          if (isOAuth()) {
                            // print(isOAuth());
                          } else {
                            UserActions()
                                .login(frmValues['user'].toString(),
                                    frmValues['password'].toString())
                                .then((value) {
                              if (value.statusCode == 401) {
                                showMessage(
                                    context, 'Usuario o contraseña inválidos');
                              } else if (value.statusCode == 503) {
                                showMessage(context, 'Servicio no disponible');
                              } else if (value.statusCode == 200) {
                                Navigator.pushNamed(context, 'dashboard');
                              }
                            });
                          }
                        }
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  isOAuth() {
    return endpoints['use_OAuth'];
  }

  showMessage(context, message) {
    showAdaptiveDialog(
        barrierDismissible:
            false, // Permite cerrar el modal cuando se hace clikc afuera
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text(
              'Error',
              textAlign: TextAlign.center,
            ), // Titulo de la card
            content: Column(
              mainAxisSize:
                  MainAxisSize.min, // Ajusta la card al texto mas pequenho
              children: [
                Text(message),
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
}
