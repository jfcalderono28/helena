import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';

class AlergiaMedicaNueva extends StatefulWidget {
  const AlergiaMedicaNueva({Key? key}) : super(key: key);

  @override
  State<AlergiaMedicaNueva> createState() => MedicamentosNuevo();
}

class MedicamentosNuevo extends State<AlergiaMedicaNueva> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController(text: "");
  TextEditingController descripcionController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicina"),
      ),
      body: formulario(context),
      bottomNavigationBar: const BottomAppBar(
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
          borderRadius: BorderRadius.circular(50),
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
                  hintText: "Ingresa nombre de la alergia medica",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese ua alergia válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: TextFormField(
                  controller: descripcionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: "Descripción de la alergia",
                    border: OutlineInputBorder(),
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
                    bool existe = await validarAlergiaExistente(nombreAlergia);

                    if (!existe) {
                      await registrarAlergia(
                        nombreAlergia,
                        descripcionController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Alergia agregada correctamente')),
                      );
                    } else {
                      // Muestra una alerta para confirmar la actualización o eliminación
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('La alergia ya está registrada'),
                            content:
                                const Text('¿Qué desea hacer con la alergia?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Actualizar'),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // Cerrar el AlertDialog
                                  await actualizarAlergia(
                                    nombreAlergia,
                                    descripcionController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Alergia actualizada correctamente')),
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text('Eliminar'),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // Cerrar el AlertDialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar alergia'),
                                        content: const Text(
                                            '¿Está seguro de que desea eliminar la alergia?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('No'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Cerrar el AlertDialog
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Sí'),
                                            onPressed: () async {
                                              Navigator.of(context)
                                                  .pop(); // Cerrar el AlertDialog
                                              await deleteAlergiaPorNombre(
                                                  nombreAlergia);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Alergia eliminada correctamente')),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Cerrar el AlertDialog
                                },
                              ),
                            ],
                          );
                        },
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
