import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';
import 'package:intl/intl.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController correoController = TextEditingController(text: "");

  TextEditingController nombre = TextEditingController(text: "");
  TextEditingController apellido = TextEditingController(text: "");
  TextEditingController uidTEC = TextEditingController(text: "");
  TextEditingController celular = TextEditingController(text: "");
  TextEditingController direccion = TextEditingController(text: "");
  TextEditingController emailTEC = TextEditingController(text: "");
  TextEditingController fechaNacimiento = TextEditingController(text: "");
  TextEditingController contrasenha = TextEditingController(text: "");

  String uid = "";
  String uidPaciente = "";
  String email = "";

  bool paciente = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: formulario(context),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF019C71),
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('PaginaInicioAdmin');
              },
              child: const Text(
                "Atrás",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formulario(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                    controller: correoController,
                    decoration: const InputDecoration(
                      hintText: "Ingresa correo electronico del nombre",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el correo electrónico';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Por favor, ingresa un correo electrónico válido';
                      }
                      return null;
                    }),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    getCuidador(correoController.text).then((value) {
                      if (value.isNotEmpty) {
                        for (var element in value) {
                          nombre.text = element["nombre"];
                          apellido.text = element["apellido"];
                          uidTEC.text = element["uid"];
                          emailTEC.text = element["email"];
                          celular.text = element["celular"].toString();
                          contrasenha.text = element["contrasenha"];
                          direccion.text = element["direccion"];
                          fechaNacimiento.text =
                              formatFechaNacimiento(element["fechaNacimiento"]);
                          paciente = false;
                          setState(() {});
                        }
                      } else {
                        getPaciente(correoController.text).then((value) {
                          if (value.isNotEmpty) {
                            for (var element in value) {
                              nombre.text = element["nombre"];
                              apellido.text = element["apellido"];
                              uidTEC.text = element["uid"];
                              emailTEC.text = element["email"];
                              celular.text = element["celular"].toString();
                              contrasenha.text = element["contrasenha"];
                              direccion.text = element["direccion"];
                              fechaNacimiento.text = formatFechaNacimiento(
                                  element["fechaNacimiento"]);
                              paciente = true;
                              setState(() {});
                            }
                          }
                        });
                      }
                    });
                  },
                  child: const Text("Buscar usuario"),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nombre,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: apellido,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: uidTEC,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailTEC,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: celular,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: contrasenha,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: direccion,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: fechaNacimiento,
                  decoration: const InputDecoration(hintText: ""),
                  readOnly: false,
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (paciente) {
                      try {
                        int celularParsed = int.parse(celular.text);
                        DateTime fechaNacimientoParsed =
                            DateFormat('dd/MM/yyyy')
                                .parse(fechaNacimiento.text);

                        if (paciente) {
                          actualizarPaciente(
                            uidTEC.text,
                            nombre.text,
                            apellido.text,
                            contrasenha.text,
                            celularParsed,
                            emailTEC.text,
                            direccion.text,
                            fechaNacimientoParsed,
                          );
                        }
                      } catch (e) {
                        print('Error al actualizar el paciente: $e');
                      }
                    } else {
                      try {
                        int celularParsed = int.parse(celular.text);
                        DateTime fechaNacimientoParsed =
                            DateFormat('dd/MM/yyyy')
                                .parse(fechaNacimiento.text);

                        if (!paciente) {
                          actualizarCuidador(
                            uidTEC.text,
                            nombre.text,
                            apellido.text,
                            contrasenha.text,
                            celularParsed,
                            emailTEC.text,
                            direccion.text,
                            fechaNacimientoParsed,
                          );
                        }
                      } catch (e) {
                        print('Error al actualizar el cuidador: $e');
                      }
                    }
                  },
                  child: const Text("Actualizar"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: const Text(
                              "¿Estás seguro de que deseas eliminar a esta persona?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    false); // El usuario no quiere eliminar
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(
                                    true); // El usuario confirma la eliminación
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete) {
                      if (paciente) {
                        deletePeople(uidTEC.text, "paciente");
                      } else {
                        deletePeople(uidTEC.text, "cuidadores");
                      }
                    }
                  },
                  child: const Text("Eliminar"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (paciente) {
                      print(
                          "Error intenta eliminar un paciente, sí se elimina el paciente el grupo será eliminado");
                    } else {
                      eliminarDelGrupo(uidTEC.text);
                    }
                  },
                  child: const Text("Eliminar de grupo"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatFechaNacimiento(dynamic fechaNacimiento) {
    if (fechaNacimiento is Timestamp) {
      // Si el dato es un Timestamp de Firestore
      DateTime date = fechaNacimiento.toDate();
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (fechaNacimiento is String) {
      // Si el dato ya es una cadena de texto
      DateTime date = DateTime.parse(fechaNacimiento);
      return DateFormat('dd/MM/yyyy').format(date);
    }
    return fechaNacimiento.toString();
  }
}
