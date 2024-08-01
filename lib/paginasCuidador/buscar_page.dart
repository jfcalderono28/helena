import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helena/services/firebase_services.dart';

void main() => runApp(const Buscar());

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  final TextEditingController _controller = TextEditingController();
  String? _description;

  Future<List<String>> getAllSuggestions() async {
    List<String> medicamentos = await getMedicamentosBD();
    List<String> especialidades = await getEspecialidadBD();
    return [...medicamentos, ...especialidades];
  }

  Future<String?> fetchDescription(String item) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('medicamentos')
        .where('nombre', isEqualTo: item)
        .get();
    if (querySnapshot.docs.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('especialidad')
          .where('nombre', isEqualTo: item)
          .get();
    }

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      final description = data['descripcion'] as String?;
      if (description != null && description.isNotEmpty) {
        return '${description[0].toUpperCase()}${description.substring(1)}';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        home: PopScope(
          canPop: false,
          child: Scaffold(
            body: _buscar(context),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF000554e),
              title: const Text('Buscar',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushNamed(context, 'inicioCuidador');
                },
              ),
            ),
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

  Widget _buscar(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getAllSuggestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else {
          final List<String> suggestions = snapshot.data!;
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height * 0.41,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      } else {
                        return suggestions.where((String option) {
                          return option
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      }
                    },
                    onSelected: (String selection) {
                      _controller.text = selection; // Set the selected text
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      fieldTextEditingController.value = _controller.value;
                      return TextField(
                        controller: fieldTextEditingController,
                        focusNode: fieldFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Buscar',
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        final description =
                            await fetchDescription(_controller.text);
                        setState(() {
                          _description = description;
                        });
                      }
                    },
                    icon: const Icon(FontAwesomeIcons.magnifyingGlass),
                  ),
                  const SizedBox(height: 15), // Added SizedBox for spacing
                  if (_description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _description!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _bottomAction(IconData icon, int index, BuildContext context) {
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
        }
      },
    );
  }
}
