import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/iniciarSesion/iniciarSesion.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const ConfigA());

class ConfigA extends StatelessWidget {
  const ConfigA({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configuración',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF019C71),
          title: const Text(
            'Configuración',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _opciones(context),
        bottomNavigationBar: const BottomAppBar(
          //color de la barra inferior
          color: const Color(0xFF019C71),
          notchMargin: 5.0,
          shape: CircularNotchedRectangle(),
          height: 75,
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

  Widget _opciones(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(16.0), // Margen alrededor de toda la columna
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
                vertical: 18.0, horizontal: 20), // Margen vertical
            child: ElevatedButton(
              onPressed: () {
                updateUIDPaciente("");

                Navigator.of(context).pushNamed('/');
              },
              child: const Text("Cerrar Sesión"),
            ),
          ),
        ],
      ),
    );
  }
}
