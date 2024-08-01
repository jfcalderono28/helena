import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';

class AlergiaAlimentoNueva extends StatefulWidget {
  const AlergiaAlimentoNueva({super.key});

  @override
  State<AlergiaAlimentoNueva> createState() => AlergiasNueva();
}

class AlergiasNueva extends State<AlergiaAlimentoNueva> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");

  String nombreAlergia = "";
  String descripcion = "";
  String uid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alimentación"),
      ),
      body: formulario(context),
      bottomNavigationBar: const BottomAppBar(
        //color de la barra inferior
        color: Color(0xFF019C71),
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF019C71),
        onPressed: () {
          Navigator.of(context).pushNamed('PaginaInicioAdmin');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Hace el botón circular
        ),
        child: const Icon(
          Icons.home,
          color: Colors.white,
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
                controller: nombreController,
                decoration: const InputDecoration(
                  hintText: "Ingresa nombre de la alergia alimenticia",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una alergia valida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Ajusta la altura

                child: TextFormField(
                  controller: descripcionController,
                  maxLines: null, // Permite múltiples líneas
                  keyboardType:
                      TextInputType.multiline, // Teclado para múltiples líneas
                  decoration: const InputDecoration(
                    hintText: "Descripción de la alergia medica",
                    border: OutlineInputBorder(), // Borde del cuadro de texto
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese una descripción válida';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String nombreAlergia = nombreController.text.toLowerCase();
                    bool existe =
                        await validarAlergiaAlimenticiaExistente(nombreAlergia);

                    if (!existe) {
                      await registrarAlergiaAlimenticia(
                        nombreAlergia,
                        descripcionController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Alergia agregada correctamente')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('La alergia ya está registrada')),
                      );
                    }
                  }
                },
                child: const Text("Agregar alergia"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
