import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const Calendar());

class Calendar extends StatelessWidget {
  const Calendar({super.key});

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

        final List<Map<String, dynamic>> compromisos = snapshot.data ?? [];

        if (compromisos.isEmpty) {
          return const Text('No hay datos disponibles');
        }

        // Ordenar los compromisos por fecha y hora
        compromisos.sort((a, b) {
          final Timestamp horaA = a['hora'] as Timestamp;
          final Timestamp horaB = b['hora'] as Timestamp;
          return horaA.compareTo(horaB);
        });

        final now = DateTime.now();
        final List<Map<String, dynamic>> compromisosFiltrados =
            compromisos.where((compromiso) {
          final compromisoDate = (compromiso['hora'] as Timestamp).toDate();
          return compromisoDate.isAfter(now);
        }).toList();

        if (compromisosFiltrados.isEmpty) {
          return const Text('No hay próximos compromisos');
        }

        return Expanded(
          child: ListView.separated(
            itemCount: compromisosFiltrados.length,
            itemBuilder: (BuildContext context, index) {
              final compromiso = compromisosFiltrados[index];
              // Proporciona un valor predeterminado
              final hora = _formatHour(compromiso['hora'] as Timestamp);
              final lugar = compromiso['lugar'] ?? 'Lugar no especificado';
              final tipo = compromiso['tipo'] ?? 'Tipo no especificado';
              final especialidad = compromiso['especialidad'];

              final compromisoDate = (compromiso['hora'] as Timestamp).toDate();
              final bool mostrarFecha = compromisoDate.year != now.year ||
                  compromisoDate.month != now.month ||
                  compromisoDate.day != now.day;

              return ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo: $tipo',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text('Lugar: $lugar'),
                    if (especialidad != null && especialidad.isNotEmpty)
                      Text('Especialidad: $especialidad'),
                  ],
                ),
                trailing: Text(
                  mostrarFecha
                      ? '$hora - ${_formatDate(compromisoDate)}'
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
                  "Próximos compromisos",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            _list(
                getGrupoCompromisosSinCaducarStream()), // Pasar el stream a la función _list
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
        home: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF000554e),
              title: const Text(
                'Compromisos',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, 'inicioCuidador');
                },
              ),
            ),
            body: _body(),
            bottomNavigationBar: BottomAppBar(
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 0, 208, 255),
              onPressed: () {
                Navigator.of(context).pushNamed('inicioCuidador');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
