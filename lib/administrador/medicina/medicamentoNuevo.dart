import 'package:flutter/material.dart';
import 'package:helena/services/firebase_services.dart';

class MedicamentoNuevo extends StatefulWidget {
  const MedicamentoNuevo({Key? key}) : super(key: key);

  @override
  State<MedicamentoNuevo> createState() => MedicamentosNuevo();
}

class MedicamentosNuevo extends State<MedicamentoNuevo> {
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
                  hintText: "Ingresa nombre del medicamento",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un medicamento válido';
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
                    hintText: "Descripción del medicamento",
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
                    String nombreMedicamento =
                        nombreController.text.toLowerCase();
                    bool existe =
                        await validarMedicamentoExistente(nombreMedicamento);

                    if (!existe) {
                      await registrarMedicamento(
                        nombreMedicamento,
                        descripcionController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Medicamento agregado correctamente')),
                      );
                    } else {
                      // Muestra una alerta para confirmar la actualización o eliminación
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                const Text('El medicamento ya está registrado'),
                            content: const Text(
                                '¿Qué desea hacer con el medicamento?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Actualizar'),
                                onPressed: () async {
                                  Navigator.of(context)
                                      .pop(); // Cerrar el AlertDialog
                                  await actualizarMedicamento(
                                    nombreMedicamento,
                                    descripcionController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Medicamento actualizado correctamente')),
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
                                        title:
                                            const Text('Eliminar medicamento'),
                                        content: const Text(
                                            '¿Está seguro de que desea eliminar el medicamento?'),
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
                                              await deleteMedicamentoPorNombre(
                                                  nombreMedicamento);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Medicamento eliminado correctamente')),
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
                child: const Text("Agregar medicamento"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
