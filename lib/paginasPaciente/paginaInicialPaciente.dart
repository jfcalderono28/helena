import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/services/firebase_services.dart';

class PaginaInicioPaciente extends StatefulWidget {
  const PaginaInicioPaciente({
    Key? key,
  }) : super(key: key);

  @override
  State<PaginaInicioPaciente> createState() => _HomeState();
}

class _HomeState extends State<PaginaInicioPaciente> {
  late Future<List<Map<String, dynamic>>> _grupoFuture;
  late Future<List<Map<String, dynamic>>> _pacienteFuture;

  @override
  void initState() {
    super.initState();
    _grupoFuture = getGrupo();
    _pacienteFuture = getPacienteDatos()
        .then((value) => value.cast<Map<String, dynamic>>().toList());
  }

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
          Navigator.of(context).pushNamed('configP');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF000554e),
        title: FutureBuilder<List<Map<String, dynamic>>>(
          future: _pacienteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              var paciente = snapshot.data!.first;
              return Text(
                '${paciente["nombre"]} ${paciente["apellido"]}',
                style: const TextStyle(color: Colors.white),
              ); // Mostrar el nombre y apellido del paciente
            } else {
              return const Text(
                  'Cargando...'); // Muestra 'Cargando...' mientras se obtienen los datos
            }
          },
        ),
      ),
      body: listaCuidadores(context),
      bottomNavigationBar: BottomAppBar(
        //color de la barra inferior
        color: const Color(0xFF000554e),
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _bottomAction(FontAwesomeIcons.gear, 0, context),
            const Padding(padding: EdgeInsets.only(right: 60)),
          ],
        ),
      ),
      //botón circular de la barra
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 208, 255),
        onPressed: () {
          Navigator.of(context).pushNamed('addCuidador');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.add,
        ),
      ),)
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, "addCuidador");
          setState(() {
            _grupoFuture = getGrupo();
          });
        },
        child: const Icon(Icons.add),
      ),*/
    );
  }

  Widget listaCuidadores(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _grupoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            }

            List<Map<String, dynamic>> cuidadores = snapshot.data ?? [];

            return ListView.builder(
              itemCount: cuidadores.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> cuidador = cuidadores[index];

                return Dismissible(
                  key: Key(cuidador['uid']
                      .toString()), // Debe ser único para cada elemento
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Aquí puedes implementar la lógica para eliminar el cuidador
                    // Por ejemplo:
                    eliminarDelGrupo(cuidador['uid']);
                    setState(() {
                      cuidadores.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title:
                        Text('${cuidador['nombre']} ${cuidador['apellido']}'),
                    subtitle: Text(
                        'Email: ${cuidador['email']}\nCelular: ${cuidador['celular']}'),
                    // Puedes agregar más widgets aquí para mostrar más información si es necesario
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
