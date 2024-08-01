// ignore: file_names
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';

class IniciarAdministrador extends StatefulWidget {
  const IniciarAdministrador({Key? key}) : super(key: key);

  @override
  State<IniciarAdministrador> createState() => _IniciarAdministrador();
}

class _IniciarAdministrador extends State<IniciarAdministrador> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController correoController = TextEditingController(text: "");

  TextEditingController contrasenhaController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Iniciar sesión admin"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, 'iniciarSesion');
              },
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(50.0),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: correoController,
                          decoration: const InputDecoration(
                            hintText: "Ingresa tu correo electrónico",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu correo electrónico';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Por favor, ingresa un correo electrónico válido';
                            }
                            return null;
                          }),
                      TextFormField(
                        controller: contrasenhaController,
                        decoration:
                            const InputDecoration(hintText: "Contraseña"),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Future<bool> validacion = validarInicioSesionAdmin(
                                correoController.text,
                                contrasenhaController.text);
                            validacion.then((valido) {
                              if (!valido) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'El correo o la contraseña son incorrectos'),
                                  ),
                                );
                              } else {
                                Navigator.of(context)
                                    .pushNamed("PaginaInicioAdmin");
                              }
                            });
                          }
                        },
                        child: const Text("Iniciar sesión"),
                      ),
                    ],
                  ),
                ),
              )),
        ));
  }
}

void main() {
  runApp(const MaterialApp(
    home: IniciarAdministrador(),
  ));
}
