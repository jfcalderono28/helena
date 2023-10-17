import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_field/date_field.dart';
import 'package:geolocator/geolocator.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key});

  @override
  State<AddPage> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  int selectedButtonIndex = -1;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  double longitude = 0;
  double latitude = 0;

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Widget _inicial(index) {
    if (index == -1) {
      return const Text("Selecciona una opción");
    } else if (index == 0) {
      return _medicamentos();
    } else if (index == 1) {
      return _alimentacion();
    } else if (index == 2) {
      return _citas();
    } else if (index == 3) {
      return _ubicacion();
    } else {
      return const Text("");
    }
  }

  Future<void> _requestLocationPermission() async {
    final LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // El usuario ha denegado el permiso de ubicación.
      // Puedes manejar esto mostrando un mensaje al usuario.
      throw Exception("Permiso de ubicación denegado");
    } else if (permission == LocationPermission.deniedForever) {
      // El usuario ha denegado permanentemente el permiso de ubicación.
      // Puedes mostrar un mensaje y dirigir al usuario a la configuración de la aplicación.
      throw Exception("Permiso de ubicación denegado permanentemente");
    }
  }

  Future<Position> _determinePosition() async {
    await _requestLocationPermission();
    final Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  void _modificarUbicacion() async {
    try {
      Position position = await _determinePosition();

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      // Maneja los errores aquí, como cuando el GPS está desactivado.
    }
  }

  Future<String> _ubicacionValida() async {
    if (latitude != 0 && longitude != 0) {
      return "$longitude , $latitude";
    } else {
      return "Ubicación Desconocida";
    }
  }

  void _changeButtonTappedState(int index) {
    setState(() {
      if (selectedButtonIndex == index) {
        selectedButtonIndex = -1;
        _inicial(index);
      } else {
        selectedButtonIndex = index;
        _inicial(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF019C71),
        title: const Text("Categorías"),
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF019C71),
        height: 75,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/');
              },
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicamentos() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué medicamento desea agrega?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
              decoration:
                  InputDecoration(hintText: "", border: OutlineInputBorder())),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué días debe tomarlo?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "L",
                int: "1",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "M",
                int: "1",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "M",
                int: "2",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "J",
                int: "3",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "V",
                int: "4",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "S",
                int: "5",
              ),
              RoundCheckboxWithLabel(
                value: false,
                onChanged: (value) {},
                label: "D",
                int: "6",
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿A qué hora debe tomarlo?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "hh",
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final hours = int.parse(value);
                      if (hours < 0 || hours > 23) {
                        _hoursController.text = "23";
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "mm",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final minutes = int.parse(value);
                      if (minutes < 0 || minutes > 59) {
                        _minutesController.text = "59";
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Comentarios",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            maxLines: 8,
            decoration: InputDecoration.collapsed(
                hintText: "", border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }

  Widget _alimentacion() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué comida desea agregar?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
              decoration:
                  InputDecoration(hintText: "", border: OutlineInputBorder())),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿A qué hora lo agrega?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "hh",
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final hours = int.parse(value);
                      if (hours < 0 || hours > 23) {
                        _hoursController.text = "23";
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "mm",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final minutes = int.parse(value);
                      if (minutes < 0 || minutes > 59) {
                        _minutesController.text = "59";
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Comentarios",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            maxLines: 8,
            decoration: InputDecoration.collapsed(
                hintText: "", border: OutlineInputBorder()),
          ),
        )
      ],
    );
  }

  Widget _citas() {
    DateTime? selectedDate;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué Evento desea agregar?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
              decoration:
                  InputDecoration(hintText: "", border: OutlineInputBorder())),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Agregue una fecha para el evento?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(height: 5),
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DateTimeFormField(
              decoration: const InputDecoration(
                hintText: "Seleccione una fecha",
                border: OutlineInputBorder(),
              ),
              mode: DateTimeFieldPickerMode.date,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null) {
                  return 'Por favor, seleccione una fecha válida';
                }
                return null;
              },
              onDateSelected: (DateTime value) {
                setState(() {
                  selectedDate = value;
                });
              },
            )),

        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿A qué hora es el evento?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "hh",
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final hours = int.parse(value);
                      if (hours < 0 || hours > 23) {
                        _hoursController.text = "23";
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _minutesController,
                  maxLength: 2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "mm",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final minutes = int.parse(value);
                      if (minutes < 0 || minutes > 59) {
                        _minutesController.text = "59";
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Comentarios",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            maxLines: 8,
            decoration: InputDecoration.collapsed(
                hintText: "", border: OutlineInputBorder()),
          ),
        )
        // Resto del contenido...
      ],
    );
  }

  Widget _ubicacion() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Con quién esta?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
              decoration:
                  InputDecoration(hintText: "", border: OutlineInputBorder())),
        ),
        const SizedBox(
          height: 20,
        ),

        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Dónde esta?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                onPressed: () async {
                  _modificarUbicacion();
                },
                child: const Text("Ubicación actual"),
              ),
            ),
            const SizedBox(
              width: 20, // Adjust the width as needed
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FutureBuilder<String>(
                future: _ubicacionValida(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the Future is still running
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If an error occurred
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // If the Future completed successfully
                    return Text(snapshot.data ?? '');
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),

        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "Comentarios",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            maxLines: 8,
            decoration: InputDecoration.collapsed(
                hintText: "", border: OutlineInputBorder()),
          ),
        )
        // Resto del contenido...
      ],
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _categoriasSeleccionar(),
        SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _inicial(selectedButtonIndex),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoriasSeleccionar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _bottomAction(FontAwesomeIcons.pills, 0),
        _bottomAction(FontAwesomeIcons.bowlRice, 1),
        _bottomAction(FontAwesomeIcons.calendarDays, 2),
        _bottomAction(FontAwesomeIcons.locationDot, 3),
      ],
    );
  }

  Widget _bottomAction(IconData icon, int index) {
    final bool isSelected = selectedButtonIndex == index;

    return InkWell(
      onTap: () {
        _changeButtonTappedState(index);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? const Color.fromARGB(255, 0, 208, 255)
              : const Color(0xFF019C71),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: AddPage(),
      ),
    ),
  );
}

class RoundCheckboxWithLabel extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String int;

  RoundCheckboxWithLabel(
      {required this.value,
      required this.onChanged,
      required this.label,
      required this.int});

  @override
  _RoundCheckboxWithLabelState createState() => _RoundCheckboxWithLabelState();
}

class _RoundCheckboxWithLabelState extends State<RoundCheckboxWithLabel> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Column(
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 17, 0, 255),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 18.0,
                color: Color.fromARGB(255, 17, 0, 255),
              ),
            ),
          ),
          const SizedBox(height: 4), // Espaciado entre el checkbox y el texto
          Text(widget.label),
        ],
      ),
    );
  }
}
