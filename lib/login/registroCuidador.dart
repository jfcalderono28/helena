import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:helena/services/firebase_services.dart';

class Registrocuidador extends StatefulWidget {
  const Registrocuidador({Key? key}) : super(key: key);

  @override
  State<Registrocuidador> createState() => _Registrocuidador();
}

class _Registrocuidador extends State<Registrocuidador> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController apellidoController = TextEditingController(text: "");
  TextEditingController celularController = TextEditingController(text: "");
  TextEditingController direccionController = TextEditingController(text: "");
  TextEditingController correoController = TextEditingController(text: "");
  TextEditingController fechaNacimientoController =
      TextEditingController(text: "");
  TextEditingController contrasenhaController = TextEditingController(text: "");
  TextEditingController confirmContrasenhaController =
      TextEditingController(text: "");

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Registro Cuidadores"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, 'registro');
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(50.0),
            child: SafeArea(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa tu nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: apellidoController,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa tu apellido',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu apellido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: celularController,
                      decoration: const InputDecoration(
                        hintText: 'Ingresa tu número de celular',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu número de celular';
                        }
                        if (value.length != 10) {
                          return 'El número de celular debe tener 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: fechaNacimientoController,
                      decoration: const InputDecoration(
                        hintText: 'Fecha de nacimiento',
                      ),
                      readOnly: true,
                      onTap: () {
                        _seleccionarFecha(context);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecciona tu fecha de nacimiento';
                        }
                        return null;
                      },
                    ),
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
                      },
                    ),
                    TextFormField(
                      controller: direccionController,
                      decoration: const InputDecoration(
                        hintText: "Ingresa tu dirección",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu dirección';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: contrasenhaController,
                      decoration: const InputDecoration(hintText: "Contraseña"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu contraseña';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: confirmContrasenhaController,
                      decoration: const InputDecoration(
                          hintText: "Confirmar contraseña"),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirma tu contraseña';
                        }
                        if (value != contrasenhaController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          getCuidador(correoController.text).then((value) {
                            if (value.isEmpty) {
                              registrarCuidador(
                                nombreController.text,
                                apellidoController.text,
                                contrasenhaController.text,
                                int.parse(celularController.text),
                                correoController.text,
                                direccionController.text,
                                DateTime.parse(fechaNacimientoController.text),
                              );
                              Navigator.of(context)
                                  .pushNamed("iniciarSesionCuidador");
                            } else {
                              // Mostrar mensaje de correo electrónico ya existente
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('El correo electrónico ya existe.'),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: const Text("Registrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        fechaNacimientoController.text =
            fechaSeleccionada.toString().split(' ')[0];
      });
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: Registrocuidador(),
  ));
}
