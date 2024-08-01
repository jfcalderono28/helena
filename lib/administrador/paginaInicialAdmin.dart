import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/services/firebase_services.dart';

class PaginaInicioAdmin extends StatefulWidget {
  const PaginaInicioAdmin({
    Key? key,
  }) : super(key: key);

  @override
  State<PaginaInicioAdmin> createState() => _HomeState();
}

class _HomeState extends State<PaginaInicioAdmin> {
  late Future<List<Map<String, dynamic>>> _adminFuture;

  @override
  void initState() {
    super.initState();
    _adminFuture = getAdminDatos()
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
          Navigator.of(context).pushNamed('configA');
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
        backgroundColor: const Color(0xFF019C71),
        title: FutureBuilder<List<Map<String, dynamic>>>(
          future: _adminFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              var admin = snapshot.data!.first;
              return Text(
                  '${admin["usuario"]}'); // Mostrar el nombre y apellido del paciente
            } else {
              return const Text(
                  'Cargando...'); // Muestra 'Cargando...' mientras se obtienen los datos
            }
          },
        ),
      ),
      body: _body(context),
      bottomNavigationBar: BottomAppBar(
        //color de la barra inferior
        color: const Color(0xFF019C71),
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
      ),)
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_alimentacion(context), _medicina(context)],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_usuario(context)],
        )
      ],
    );
  }

  Widget _usuario(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla correspondiente
          Navigator.pushNamed(context, 'Usuarios');
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.40,
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.user,
                size: 150,
                color: Color(0xFF019C71),
              ),
              Text("Usuarios",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))
            ],
          ),
        ),
      ),
    );
  }

  Widget _medicina(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla correspondiente
          Navigator.pushNamed(context, 'Medicina');
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.40,
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.pills,
                size: 150,
                color: Color(0xFF019C71),
              ),
              Text("Medicina",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))
            ],
          ),
        ),
      ),
    );
  }

  Widget _alimentacion(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla correspondiente
          Navigator.pushNamed(context, 'alergiaAlimentoNueva');
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
          height: MediaQuery.of(context).size.height * 0.40,
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.bowlFood,
                size: 150,
                color: Color(0xFF019C71),
              ),
              Text("Alimentación",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))
            ],
          ),
        ),
      ),
    );
  }
}
