import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/pages/add_page.dart';
import 'package:helena/pages/pills_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        }
      },
    );
  }

  Widget _medicina(BuildContext context) {
    return Center(
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
              color: Color.fromARGB(255, 0, 208, 255),
            ),
            Text("Próximo medicamento",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text("Acetaminofen", style: TextStyle(fontSize: 15)),
            Text("12:00 pm", style: TextStyle(fontSize: 13))
          ],
        ),
      ),
    );
  }

  Widget _alimentacion(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Container(
          color: const Color.fromARGB(55, 158, 158, 158), // Color de fondo gris
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.bowlRice,
                size: 150,
                color: Color(0xFF019C71),
              ),
              Text("Última cena",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Text("Desayuno", style: TextStyle(fontSize: 15)),
              Text("9:00 am", style: TextStyle(fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }

  Widget _citas(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: MediaQuery.of(context).size.height * 0.41,
        child: Container(
          color: const Color.fromARGB(55, 158, 158, 158), // Color de fondo gris
          child: const Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra los elementos verticalmente
            children: [
              Icon(
                FontAwesomeIcons.calendarDays,
                size: 150,
                color: Color(0xFF019C71),
              ),
              Text(""),
              Text("Próxima cita",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              Text("Endocrinología", style: TextStyle(fontSize: 15)),
              Text("24-10-2023", style: TextStyle(fontSize: 13)),
              Text("11:00 am", style: TextStyle(fontSize: 13))
            ],
          ),
        ),
      ),
    );
  }

  Widget _ubicacion(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.50,
        height: MediaQuery.of(context).size.height * 0.41,
        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra los elementos verticalmente
          children: [
            Icon(
              FontAwesomeIcons.locationDot,
              size: 150,
              color: Color.fromARGB(255, 0, 208, 255),
            ),
            Text(""),
            Text(""),
            Text("Ubicación actual",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text("Terreros-Soacha-Colombia", style: TextStyle(fontSize: 13))
          ],
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
          children: [
            _medicina(context),
            _alimentacion(context),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_citas(context), _ubicacion(context)],
        )
      ],
    );
  }

  Widget _home(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF019C71),
          title: const Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "Maria Helena Orjuela",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 155),
              Icon(FontAwesomeIcons.comment),
            ],
          )),

      body: _body(context),

      bottomNavigationBar: BottomAppBar(
        //color de la barra inferior
        color: const Color(0xFF019C71),
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
            _bottomAction(FontAwesomeIcons.locationDot, 3, context),
          ],
        ),
      ),
      //botón circular de la barra
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 208, 255),
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/': (context) => _home(context),
        '/add': (context) => const AddPage(),
        '/pills': (context) => const Pills(),
      },
    );
  }
}
