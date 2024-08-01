import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';

class addCuidador extends StatefulWidget {
  const addCuidador({super.key});

  @override
  State<addCuidador> createState() => _addCuidadorState();
}

class _addCuidadorState extends State<addCuidador> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController correoController = TextEditingController(text: "");

  TextEditingController usuario = TextEditingController(text: "");
  String uidCuidador = "";
  String uidPaciente = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: formulario(context),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF000554e),
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('inicioPaciente');
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                    controller: correoController,
                    decoration: const InputDecoration(
                      hintText: "Ingresa correo electronico del Cuidador",
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
                const SizedBox(height: 30),
                TextFormField(
                  controller: usuario,
                  decoration: const InputDecoration(hintText: ""),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    getCuidador(correoController.text).then((value) {
                      for (var element in value) {
                        usuario.text = element["nombre"];
                        uidCuidador = element["uid"];
                        email = element["email"];
                        setState(() {});
                      }
                    });
                  },
                  child: const Text("Buscar Cuidador"),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (uidCuidador.isNotEmpty) {
                      registrarCuidadorEnGrupo(uidCuidador);
                    }
                  },
                  child: const Text("Agregar a tu grupo"),
                ),
              ],
            ),
          ),
        ));
  }
}
