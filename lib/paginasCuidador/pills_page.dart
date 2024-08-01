import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const Pills());

class Pills extends StatelessWidget {
  const Pills({super.key});

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

  Widget _list(Stream<List<Map<String, dynamic>>?> stream) {
    return StreamBuilder<List<Map<String, dynamic>>?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final List<Map<String, dynamic>> medicamentos = snapshot.data ?? [];

        if (medicamentos.isEmpty) {
          return const Text('No hay datos disponibles');
        }

        // Ordenar los medicamentos por fecha y hora
        medicamentos.sort((a, b) {
          final Timestamp horaA = a['hora'] as Timestamp;
          final Timestamp horaB = b['hora'] as Timestamp;
          return horaA.compareTo(horaB);
        });

        final now = DateTime.now();
        final List<Map<String, dynamic>> medicamentosFiltrados =
            medicamentos.where((medicamento) {
          final medicamentoDate = (medicamento['hora'] as Timestamp).toDate();
          return medicamentoDate.isAfter(now);
        }).toList();

        if (medicamentosFiltrados.isEmpty) {
          return const Text('No hay próximosmedicamentos');
        }

        return Expanded(
          child: ListView.separated(
            itemCount: medicamentosFiltrados.length,
            itemBuilder: (BuildContext context, index) {
              final medicamento = medicamentosFiltrados[index];
              final nombre = medicamento['nombre'];
              final hora = _formatHour(medicamento['hora'] as Timestamp);

              final medicamentoDate =
                  (medicamento['hora'] as Timestamp).toDate();
              final bool mostrarFecha = medicamentoDate.year != now.year ||
                  medicamentoDate.month != now.month ||
                  medicamentoDate.day != now.day;

              return ListTile(
                leading: TextButton(
                  onPressed: () async {
                    // Obtener información del medicamento
                    List medicamentoInfo = await getInfoMedicamentos(nombre);

                    // Crear un AlertDialog con la información del medicamento
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String nombreCapitalizado =
                            medicamentoInfo[0]['nombre'].replaceRange(
                          0,
                          1,
                          medicamentoInfo[0]['nombre'][0].toUpperCase(),
                        );
                        String descripcionCapitalizado =
                            medicamentoInfo[0]['descripcion'].replaceRange(
                          0,
                          1,
                          medicamentoInfo[0]['descripcion'][0].toUpperCase(),
                        );

                        return AlertDialog(
                          title: Text(nombreCapitalizado),
                          content: Text(descripcionCapitalizado),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    nombre,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                trailing: Text(
                  mostrarFecha
                      ? '$hora - ${_formatDate(medicamentoDate)}'
                      : hora,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                height: 2.0,
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatHour(Timestamp hora) {
    final DateTime dateTime = hora.toDate();
    final String formattedHour =
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formattedHour;
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Title(
                color: Colors.black,
                child: const Text(
                  "Próximos medicamentos",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            _list(
                getGrupoMedicamentosSinCaducarStream()), // Pasar el stream a la función _list
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF000554e),
          title: const Text(
            'Medicamentos',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: _body(),
        bottomNavigationBar: BottomAppBar(
          //color de la barra inferior
          color: const Color(0xff000554e),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 208, 255),
          onPressed: () {
            Navigator.of(context).pushNamed('inicioCuidador');
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.home,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
