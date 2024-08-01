import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const Food());

class Food extends StatelessWidget {
  const Food({super.key});

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
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF000554e),
          title: const Text('Alimentos',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
        body: const Body(),
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

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final Map<String, bool> comidas = {
    'Desayuno': false,
    'Pre Almuerzo': false,
    'Almuerzo': false,
    'Post Almuerzo': false,
    'Cena': false,
  };

  @override
  void initState() {
    super.initState();
  }

  void _updateCheckboxState(List<Map<String, dynamic>> alimentacion) {
    Map<String, bool> updatedComidas = {
      'Desayuno': false,
      'Pre Almuerzo': false,
      'Almuerzo': false,
      'Post Almuerzo': false,
      'Cena': false,
    };

    for (var alimento in alimentacion) {
      if (alimento.containsKey("comida")) {
        String comida = alimento["comida"];
        if (updatedComidas.containsKey(comida)) {
          updatedComidas[comida] = true;
        }
      }
    }

    Future.microtask(() {
      if (mounted) {
        setState(() {
          comidas.addAll(updatedComidas);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "¿Qué ha comido hoy?",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 25),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: getGrupoAlimentacionInfoStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _updateCheckboxState(snapshot.data!);
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                } else {
                  print('Cargando datos...');
                }
                return Column(
                  children: comidas.keys.map((String key) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: comidas[key],
                              onChanged: (bool? value) {
                                setState(() {
                                  comidas[key] = value!;
                                });
                              },
                            ),
                            Text(key),
                          ],
                        ),
                        const SizedBox(
                            height: 20), // Espacio entre los checkboxes
                      ],
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 25),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _itemAlergias(String name, String description) {
    return ListTile(
      title: Text(name),
      subtitle: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
