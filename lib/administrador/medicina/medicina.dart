import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const Medicina());

class Medicina extends StatelessWidget {
  const Medicina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicina"),
      ),
      body: _body(context),
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

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_vacio(context)],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _medicamentosNuevos(context),
            const SizedBox(
              width: 15,
            ),
            _alergiasNuevas(context)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_vacio(context)],
        ),
      ],
    );
  }

  Widget _vacio(BuildContext context) {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.15),
    );
  }

  Widget _medicamentosNuevos(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla correspondiente
          Navigator.pushNamed(context, 'medicamentoNuevo');
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: const BoxDecoration(
            color: Color.fromARGB(
                255, 0, 208, 255), // Establece el color de fondo a verde
            // Agrega el borde negro
          ),
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Text(
                "Medicamentos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(
                height: 15,
              ),
              Icon(
                FontAwesomeIcons.pills,
                size: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alergiasNuevas(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla correspondiente
          Navigator.pushNamed(context, 'alergiaMedicaNueva');
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: const BoxDecoration(
            color: Color(0xFF019C71),
            // Agrega el borde negro
          ),
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmRente
            children: [
              Text(
                "Alergias",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(
                height: 15,
              ),
              Icon(
                FontAwesomeIcons.radiation,
                size: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
