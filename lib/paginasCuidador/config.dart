import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/iniciarSesion/iniciarSesion.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const Config());

class Config extends StatelessWidget {
  const Config({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Configuración',
        debugShowCheckedModeBanner: false,
        home: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF000554e),
              title: const Text(
                'Configuración',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, 'inicioCuidador');
                },
              ),
            ),
            body: _opciones(context),
            bottomNavigationBar: const BottomAppBar(
              //color de la barra inferior
              color: Color(0xff000554e),
              notchMargin: 5.0,
              shape: CircularNotchedRectangle(),
              height: 75,
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
