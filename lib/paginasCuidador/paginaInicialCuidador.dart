import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/iniciarSesion/iniciarSesion.dart';
import 'package:helena/paginasCuidador/add_page.dart';
import 'package:helena/paginasCuidador/buscar_page.dart';
import 'package:helena/paginasCuidador/calendar_page.dart';
import 'package:helena/paginasCuidador/config.dart';
import 'package:helena/paginasCuidador/food_page.dart';
import 'package:helena/paginasCuidador/pills_page.dart';
import 'package:helena/services/firebase_services.dart';
import 'package:intl/intl.dart';

void main() => runApp(const PaginaInicioCuidador());

class PaginaInicioCuidador extends StatelessWidget {
  const PaginaInicioCuidador({super.key});

  Widget _bottomAction(IconData icon, int index, BuildContext context) {
    //botones de la barra inferior
    return InkWell(
      child: Icon(
        icon,
        size: 35,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushNamed('/pills');
        } else if (index == 1) {
          Navigator.of(context).pushNamed('/alimentos');
        } else if (index == 2) {
          Navigator.of(context).pushNamed('/calendario');
        } else if (index == 3) {
          Navigator.of(context).pushNamed('/config');
        }
      },
    );
  }

  Widget _medicina(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getGrupoMedicamentosStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
        }

        if (snapshot.hasError) {
          print("${snapshot.error}");
          return const Text('Error al obtener los medicamentos');
          // Muestra un mensaje de error si ocurre un problema
        }

        List<Map<String, dynamic>> medicamentos = snapshot.data ?? [];

        if (medicamentos.isEmpty) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.41,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.pills,
                    size: 150,
                    color: Color.fromARGB(255, 0, 208, 255),
                  ),
                  Text(
                    "Próximo medicamento",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    "No hay medicamentos registrados",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ); // Muestra un mensaje si no hay medicamentos
        }

        // Obtener el medicamento más próximo
        Map<String, dynamic> ultimoMedicamento = medicamentos.first;

        // Formatear la hora
        Timestamp timestamp = ultimoMedicamento["hora"];
        DateTime MedicamentoDateTime = timestamp.toDate();
        DateTime today = DateTime.now();

        String formattedTime = DateFormat.Hm().format(MedicamentoDateTime);
        String formattedDate = DateFormat.yMMMd().format(MedicamentoDateTime);

        String displayDate =
            MedicamentoDateTime.day == today.day ? '' : formattedDate;

        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.height * 0.41,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.pills,
                  size: 150,
                  color: Color.fromARGB(255, 0, 208, 255),
                ),
                const Text(
                  "Próximo medicamento",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  '${ultimoMedicamento["nombre"]![0].toUpperCase()}${ultimoMedicamento["nombre"]!.substring(1)}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  formattedTime,
                  style: const TextStyle(fontSize: 13),
                ),
                if (displayDate.isNotEmpty)
                  Text(
                    displayDate,
                    style: const TextStyle(fontSize: 13),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _alimentacion(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getGrupoAlimentacionStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error al obtener los alimentos');
        }

        List<Map<String, dynamic>> alimentacion = snapshot.data ?? [];

        if (alimentacion.isEmpty) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.41,
              child: Container(
                color: const Color.fromARGB(
                    55, 158, 158, 158), // Color de fondo gris
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos verticalmente
                  children: [
                    Icon(
                      FontAwesomeIcons.bowlRice,
                      size: 150,
                      color: const Color(0xFF000554e),
                    ),
                    Text("Ultimo alimento",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    Text("No hay alimentos registrados",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ); // Muestra un mensaje si no hay medicamentos
        }

        // Obtener el medicamento más próximo
        Map<String, dynamic> ultimoAlimento = alimentacion.first;

        // Convertir el Timestamp a DateTime
        Timestamp timestamp = ultimoAlimento["hora"] as Timestamp;
        DateTime alimentoDateTime = timestamp.toDate();
        DateTime today = DateTime.now();

        String formattedTime = DateFormat.Hm().format(alimentoDateTime);
        String formattedDate = DateFormat.yMMMd().format(alimentoDateTime);

        String displayDate =
            alimentoDateTime.day == today.day ? '' : formattedDate;

        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.height * 0.41,
            child: Container(
              color: const Color.fromARGB(55, 158, 158, 158),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.bowlRice,
                    size: 150,
                    color: const Color(0xFF000554e),
                  ),
                  const Text(
                    "Alimentación",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text(
                    '${ultimoAlimento["comida"]![0].toUpperCase()}${ultimoAlimento["comida"]!.substring(1)}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (displayDate.isNotEmpty)
                    Text(
                      displayDate,
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _citas(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getGrupoCitasStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error al obtener las citas');
        }

        List<Map<String, dynamic>> citas = snapshot.data ?? [];

        if (citas.isEmpty) {
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.41,
              child: Container(
                color: const Color.fromARGB(
                    55, 158, 158, 158), // Color de fondo gris
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos verticalmente
                  children: [
                    Icon(
                      FontAwesomeIcons.calendar,
                      size: 150,
                      color: const Color(0xFF000554e),
                    ),
                    Text("Ultima cita",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    Text("No hay citas registradas",
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        }

        // Obtener la última cita
        Map<String, dynamic> ultimaCita = citas.first;

        // Verificar si las claves existen
        String cita = ultimaCita.containsKey("tipo") ? ultimaCita["tipo"]! : "";
        String direccion =
            ultimaCita.containsKey("lugar") ? ultimaCita["lugar"]! : "";
        String especialidad = ultimaCita.containsKey("especialidad")
            ? ultimaCita["especialidad"]!
            : "";
        Timestamp? timestamp = ultimaCita.containsKey("hora")
            ? ultimaCita["hora"] as Timestamp
            : null;

        DateTime citaDateTime = timestamp?.toDate() ?? DateTime.now();
        DateTime today = DateTime.now();

        String formattedTime = DateFormat.Hm().format(citaDateTime);
        String formattedDate = DateFormat.yMMMd().format(citaDateTime);

        String displayDate = citaDateTime.day == today.day ? '' : formattedDate;

        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.50,
            height: MediaQuery.of(context).size.height * 0.41,
            child: Container(
              color: const Color.fromARGB(55, 158, 158, 158),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.calendar,
                    size: 150,
                    color: const Color(0xFF000554e),
                  ),
                  const Text(
                    "Próxima cita",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  if (cita.isNotEmpty)
                    Text(
                      'tipo: ${cita[0].toUpperCase()}${cita.substring(1)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  if (especialidad.isNotEmpty)
                    Text(
                      ' $especialidad',
                      style: const TextStyle(fontSize: 15),
                    ),
                  Text(
                    formattedTime,
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (displayDate.isNotEmpty)
                    Text(
                      displayDate,
                      style: const TextStyle(fontSize: 13),
                    ),
                  if (direccion.isNotEmpty)
                    Text(
                      direccion,
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buscar(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: MediaQuery.of(context).size.height * 0.41,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
                '/buscar'); // Cambia '/searchPage' por la ruta correcta de tu página de búsqueda
          },
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 150,
                color: Color.fromARGB(255, 0, 208, 255),
              ),
              Text(
                "Buscar",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_medicina(context), _alimentacion(context)],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_citas(context), _buscar(context)],
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF000554e),
            title: FutureBuilder<List>(
              future: getCuidadorDatos(),
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List cuidadores = snapshot.data ?? [];
                  if (cuidadores.isNotEmpty) {
                    Map<String, dynamic> cuidador = cuidadores.first;
                    String nombreCuidador = cuidador["nombre"];
                    String apellidoCuidador = cuidador["apellido"];
                    return Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                          '$nombreCuidador $apellidoCuidador',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 155),
                      ],
                    );
                  } else {
                    return const Text('Cuidador no encontrado');
                  }
                }
              },
            )
          ),

          body: _body(context),

          bottomNavigationBar: BottomAppBar(
            //color de la barra inferior
            color: const Color(0xFF000554e),
            notchMargin: 5.0,
            shape: const CircularNotchedRectangle(),
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomAction(FontAwesomeIcons.pills, 0, context),
                _bottomAction(FontAwesomeIcons.bowlRice, 1, context),
                const SizedBox(width: 10),
                _bottomAction(FontAwesomeIcons.calendarDays, 2, context),
                _bottomAction(FontAwesomeIcons.gear, 3, context),
              ],
            ),
          ),
          //botón circular de la barra
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 0, 208, 255),
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: const Icon(
              Icons.add,
            ),
          ),
        ));
  }
}
