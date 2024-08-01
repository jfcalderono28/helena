import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_field/date_field.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helena/services/firebase_services.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key});

  @override
  State<AddPage> createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  int selectedButtonIndex = -1;
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();

  double longitude = 0;
  double latitude = 0;

  int medicamentos = 0;
  int alimentacion = 0;
  int citas = 0;

  bool mostrarSelectorHoraFecha = false;
  bool mostrarIntervalo = false;
  bool mostrarDuracion = false;
  bool mostrarEspecialidad = false;
  bool mostrarDireccion = false;

  bool isDireccionEmpty = false;
  bool isDireccionValida = false;

  bool isFechaHoraSeleccionada = false;

  DateTime? selectedDateTime;
  TextEditingController intervaloController = TextEditingController();
  TextEditingController duracionController = TextEditingController();

  String medicamento = "";
  String especialidad = "";
  int recurrencia = 0;

  String? opcionSeleccionada;

  final commonInputDecoration = const InputDecoration(
    hintStyle: TextStyle(fontSize: 10),
    // Puedes personalizar el placeholder aquí
    border: OutlineInputBorder(),
  );

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Widget _inicial(index, int medicamentos, int alimentacion) {
    if (index == -1) {
      return const Column(
        children: [
          SizedBox(height: 150),
          Text(
            "Selecciona una opción",
            style: TextStyle(fontSize: 20),
          ),
        ],
      );
    } else if (index == 0) {
      if (medicamentos == 0) {
        return _agregarMedicamento();
      } else if (medicamentos == 1) {
        return _agregarHorarioMedicamento();
      }
    } else if (index == 1) {
      if (alimentacion == 0) {
        return _agregarAlimentacion();
      } else if (alimentacion == 1) {
        return _agregarHorarioAlimentacion();
      }
    } else if (index == 2) {
      if (citas == 0) {
        return _agregarCita();
      } else if (citas == 1) {
        return _agregarHorarioCitas();
      }
    } else if (index == 3) {
      return _ubicacion();
    }
    // Añadir un retorno por defecto
    return const Text("");
  }

  //medicamentos
  //        ? _agregarMedicamento()
  //        : _agregarHorarioMedicamento();

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
        _inicial(index, medicamentos, alimentacion);
      } else {
        selectedButtonIndex = index;
        _inicial(index, medicamentos, alimentacion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF000554e),
            title: const Text(
              "Categorías",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, 'inicioCuidador');
              },
            ),
          ),
          body: SingleChildScrollView(
            child: _body(),
          ),
          bottomNavigationBar: const BottomAppBar(
            //color de la barra inferior
            color: Color(0xFF000554e),
            notchMargin: 5.0,
            shape: CircularNotchedRectangle(),
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF00D0FF),
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
        ));
  }

  Widget _agregarMedicamento() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué medicamento desea agregar?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) async {
              if (textEditingValue.text == "") {
                return const Iterable<String>.empty();
              }
              return await getMedicamentosBD(); // Utilizando la función modificada
            },
            onSelected: (String item) {
              medicamento = item;
              print("the $item was selected");
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        if (medicamento != "") {
                          setState(() {
                            medicamentos = 1;
                          });
                        }
                      },
                      icon: const Icon(Icons.last_page),
                      label: const Text("")),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _agregarHorarioMedicamento() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Recurrencia?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                recurrencia = 1;
                // Cuando el usuario elige "Una vez", mostramos el selector de hora y fecha
                setState(() {
                  mostrarSelectorHoraFecha = true;
                  mostrarIntervalo = false;
                  mostrarDuracion = false; // Ocultar el input de intervalo
                });
              },
              child: const Text("Una vez"),
            ),
            ElevatedButton(
              onPressed: () {
                recurrencia = 2;
                // Cuando el usuario elige "Varias veces", mostramos el selector de hora y fecha y el input de intervalo
                setState(() {
                  mostrarSelectorHoraFecha = true;
                  mostrarIntervalo = true;
                  mostrarDuracion = true;
                });
              },
              child: const Text("Varias veces"),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Mostrar el selector de hora y fecha si se seleccionó "Una vez" o "Varias veces"
        if (mostrarSelectorHoraFecha) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DateTimeFormField(
              decoration: const InputDecoration(
                hintText: "Seleccione una fecha y hora",
                border: OutlineInputBorder(),
              ),
              mode: DateTimeFieldPickerMode.dateAndTime,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value == null) {
                  return 'Por favor, seleccione una fecha y hora válida';
                }
                return null;
              },
              onDateSelected: (DateTime value) {
                setState(() {
                  selectedDateTime = value;
                });
              },
            ),
          ),
          // Mostrar el input de intervalo solo si se seleccionó "Varias veces"
          if (mostrarIntervalo) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: intervaloController,
                decoration: const InputDecoration(
                  hintText: "Intervalo (en horas)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ],
          if (mostrarDuracion) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: duracionController,
                decoration: const InputDecoration(
                  hintText: "¿Cuantas veces debe tomar el medicamento?",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ],
        ],
        const SizedBox(height: 45),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          medicamentos = 0;
                        });
                      },
                      icon: const Icon(Icons.first_page),
                      label: const Text("")),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (recurrencia > 0) {
                          if (recurrencia == 1 &&
                              medicamento != "" &&
                              selectedDateTime != "") {
                            Map<String, dynamic> medicamentoData = {
                              "nombre": medicamento,
                              "hora": selectedDateTime,
                              // Agrega otras propiedades del medicamento según sea necesario
                            };

// Empaqueta el medicamento en una lista y pásalo a la función

                            agregarMedicamentoAGrupo([medicamentoData]);

                            print("$medicamento");
                            print("$selectedDateTime");
                            setState(() {
                              medicamentos = 0;
                              Navigator.of(context).pushNamed('inicioCuidador');
                            });
                          } else {
                            if (recurrencia == 2 &&
                                medicamento != "" &&
                                selectedDateTime != null &&
                                intervaloController.text != "" &&
                                duracionController.text != "") {
                              // Crear la lista de medicamentos con intervalos
                              List<Map<String, dynamic>>
                                  medicamentosConIntervalo = [];

                              // Calcular la próxima hora inicial
                              DateTime proximaHora =
                                  selectedDateTime!; // Agregamos el operador de aserción de no nulo (!) aquí

                              // Convertir la duración a un entero
                              int duracion =
                                  int.tryParse(duracionController.text) ?? 0;

                              // Convertir el intervalo a un entero
                              int intervalo =
                                  int.tryParse(intervaloController.text) ?? 0;

                              // Crear y agregar los medicamentos con intervalo a la lista
                              for (int i = 0; i < duracion; i++) {
                                Map<String, dynamic> medicamentoData = {
                                  "nombre": medicamento,
                                  "hora": proximaHora,
                                  // Agregar otras propiedades del medicamento según sea necesario
                                };
                                medicamentosConIntervalo.add(medicamentoData);

                                // Añadir el intervalo a la próxima hora
                                proximaHora =
                                    proximaHora.add(Duration(hours: intervalo));
                              }

                              // Agregar los medicamentos con intervalo al grupo
                              agregarMedicamentoAGrupo(
                                  medicamentosConIntervalo); // Pasar la lista de medicamentos

                              setState(() {
                                medicamentos = 0;
                                Navigator.of(context)
                                    .pushNamed('inicioCuidador');
                              });
                            }
                          }
                        } else {}
                      },
                      icon: const Icon(Icons.last_page),
                      label: const Text("")),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _agregarAlimentacion() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué alimento desea agregar?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Desayuno'),
                leading: Radio<String>(
                  value: 'Desayuno',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      alimentacion = 1;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Pre Almuerzo'),
                leading: Radio<String>(
                  value: 'Pre Almuerzo',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      alimentacion = 1;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Almuerzo'),
                leading: Radio<String>(
                  value: 'Almuerzo',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      alimentacion = 1;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Post Almuerzo'),
                leading: Radio<String>(
                  value: 'Post Almuerzo',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      alimentacion = 1;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Cena'),
                leading: Radio<String>(
                  value: 'Cena',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      alimentacion = 1;
                    });
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
        ),
      ],
    );
  }

  Widget _agregarHorarioAlimentacion() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 45),
        Title(
            color: Colors.black,
            child: const Text(
              "Seleccione fecha y hora",
              style: TextStyle(fontSize: 25),
            )),
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: DateTimeFormField(
            decoration: const InputDecoration(
              hintText: "Seleccione una fecha y hora",
              border: OutlineInputBorder(),
            ),
            mode: DateTimeFieldPickerMode.dateAndTime,
            autovalidateMode: AutovalidateMode.always,
            lastDate:
                DateTime.now(), // Restringir la fecha mínima a la fecha actual
            validator: (value) {
              if (value == null) {
                return 'Por favor, seleccione una fecha y hora válida';
              }

              // Obtener la fecha y hora actual
              final now = DateTime.now();

              // Comparar la hora y el minuto seleccionados con la hora y el minuto actuales
              if (value.hour > now.hour ||
                  (value.hour == now.hour && value.minute > now.minute)) {
                return 'Por favor, seleccione una hora y minuto válidos';
              }

              return null;
            },
            onDateSelected: (DateTime value) {
              setState(() {
                selectedDateTime = value;
              });
            },
          ),
        ),

        const SizedBox(height: 45),
        // Mostrar el selector de hora y fecha si se seleccionó "Una vez" o "Varias veces"

        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          alimentacion = 0;
                        });
                      },
                      icon: const Icon(Icons.first_page),
                      label: const Text("")),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (selectedDateTime != "") {
                          Map<String, dynamic> AlimentoData = {
                            "comida": opcionSeleccionada,
                            "hora": selectedDateTime,
                            // Agrega otras propiedades del medicamento según sea necesario
                          };
                          agregarAlimentoGrupo([AlimentoData]);
                          Navigator.of(context).pushNamed('inicioCuidador');
                          setState(() {
                            alimentacion = 0;
                            Navigator.of(context).pushNamed('inicioCuidador');
                          });
                        }
                      },
                      icon: const Icon(Icons.last_page),
                      label: const Text("")),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _agregarCita() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 45),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "¿Qué Cita desea agregar?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Familiar'),
                leading: Radio<String>(
                  value: 'Familiar',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      citas = 1;
                      mostrarDireccion = true;
                      mostrarSelectorHoraFecha = true;
                      mostrarEspecialidad = false;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Medica'),
                leading: Radio<String>(
                  value: 'Medica',
                  groupValue: opcionSeleccionada,
                  onChanged: (String? value) {
                    setState(() {
                      opcionSeleccionada = value!;
                      citas = 1;
                      mostrarEspecialidad = true;
                      mostrarSelectorHoraFecha = true;
                      mostrarDireccion = true;
                    });
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
        ),
      ],
    );
  }

  Widget _agregarHorarioCitas() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),
        Title(
            color: Colors.black,
            child: const Text(
              "Descripción",
              style: TextStyle(fontSize: 20),
            )),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
        ),
        const SizedBox(height: 15),
        // Definir un InputDecoration común para todos los hintText

// En tu código...
        if (mostrarEspecialidad) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Autocomplete<String>(
                optionsBuilder: (textEditingValue) async {
                  final List<String> especialidades = await getEspecialidadBD();
                  if (textEditingValue.text.isEmpty) {
                    return especialidades;
                  } else {
                    final filteredOptions = especialidades
                        .where((especialidad) => especialidad
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .toList();
                    return filteredOptions.isNotEmpty
                        ? filteredOptions
                        : especialidades;
                  }
                },
                onSelected: (String item) {
                  especialidad = item;
                  print("the $item was selected");
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: const InputDecoration(
                      hintText: "Especialidad",
                      border: OutlineInputBorder(),
                    ),
                    // Aplicar el InputDecoration común
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],

        if (mostrarDireccion) ...[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  hintText: "Dirección",
                  border: OutlineInputBorder(),
                ), // Aplicar el InputDecoration común
                keyboardType: TextInputType.streetAddress,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter
                ],
                onChanged: (value) {
                  // Actualizar el estado para indicar si el campo está vacío o no
                  setState(() {
                    isDireccionEmpty = value.isEmpty;

                    isDireccionValida = _direccionController.text.length >= 10;

                    print(value.length);
                    print(isDireccionValida);
                  });
                },
              ),
            ),
          ),
          if (isDireccionEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Por favor, ingrese una dirección',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
          const SizedBox(height: 5),
          if (isDireccionValida == false)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'La dirección debe tener un mínimo de 10 caracteres',
                style: TextStyle(color: Colors.red, fontSize: 10),
              ),
            ),
          const SizedBox(height: 5),
        ],

        if (mostrarSelectorHoraFecha) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  DateTimeFormField(
                    decoration: const InputDecoration(
                      hintText: "Seleccionar fecha y hora",
                      border: OutlineInputBorder(),
                    ), // Aplicar el InputDecoration común
                    mode: DateTimeFieldPickerMode.dateAndTime,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (value == null) {
                        return '';
                      }
                      return null;
                    },
                    onDateSelected: (DateTime value) {
                      setState(() {
                        selectedDateTime = value;
                        isFechaHoraSeleccionada =
                            true; // Actualizar la variable de control
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
        if (!isFechaHoraSeleccionada)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Debe seleccionar una fecha y hora', // Mensaje de error si no se selecciona nada
              style: TextStyle(color: Colors.red, fontSize: 10),
            ),
          ),

        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          citas = 0;
                          selectedDateTime = null;
                        });
                      },
                      icon: const Icon(Icons.first_page),
                      label: const Text("")),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (selectedDateTime != "") {
                          Map<String, dynamic> CitaData = {};
                          if (especialidad == "") {
                            CitaData = {
                              "tipo": opcionSeleccionada,

                              "hora": selectedDateTime,
                              "lugar": _direccionController
                                  .text // Agrega otras propiedades del medicamento según sea necesario
                            };
                          }
                          if (especialidad != "") {
                            CitaData = {
                              "tipo": opcionSeleccionada,
                              "especialidad": especialidad,

                              "hora": selectedDateTime,
                              "lugar": _direccionController
                                  .text // Agrega otras propiedades del medicamento según sea necesario
                            };
                          }
                          if (opcionSeleccionada == "Familiar" &&
                              isDireccionValida &&
                              isDireccionEmpty == false) {
                            if (opcionSeleccionada != "" &&
                                selectedDateTime != null &&
                                _direccionController.text != "") {
                              agregarCitaGrupo([CitaData]);
                              Navigator.of(context).pushNamed('inicioCuidador');
                              setState(() {
                                citas = 0;
                                Navigator.of(context)
                                    .pushNamed('inicioCuidador');
                              });
                            } else {
                              print("No se guardo por falta de datos");
                              selectedDateTime = null;
                            }
                          } else if (opcionSeleccionada == "Medica" &&
                              isDireccionValida &&
                              isDireccionEmpty == false) {
                            if (opcionSeleccionada != "" &&
                                selectedDateTime != null &&
                                _direccionController.text != "" &&
                                especialidad != "") {
                              agregarCitaGrupo([CitaData]);
                              Navigator.of(context).pushNamed('inicioCuidador');
                              setState(() {
                                citas = 0;
                                Navigator.of(context)
                                    .pushNamed('inicioCuidador');
                              });
                            } else {
                              print("No se guardo por falta de datos");
                              selectedDateTime = null;
                            }
                          }
                          ;
                        }
                      },
                      icon: const Icon(Icons.last_page),
                      label: const Text("")),
                ],
              )
            ],
          ),
        ),
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
              _inicial(selectedButtonIndex, medicamentos, alimentacion),
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
        _bottomAction(FontAwesomeIcons.pills, 0, context),
        _bottomAction(FontAwesomeIcons.bowlRice, 1, context),
        _bottomAction(FontAwesomeIcons.calendarDays, 2, context),
      ],
    );
  }

  Widget _bottomAction(IconData icon, int index, BuildContext context) {
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
          color:
              isSelected ? const Color(0xFF019C71) : const Color(0xFF000554e),
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

class TypeAheadFormField {}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
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

  RoundCheckboxWithLabel({
    required this.value,
    required this.onChanged,
    required this.label,
    required this.int,
  });

  @override
  _RoundCheckboxWithLabelState createState() => _RoundCheckboxWithLabelState();
}

class _RoundCheckboxWithLabelState extends State<RoundCheckboxWithLabel> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChanged(isChecked);
      },
      child: Column(
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isChecked
                    ? const Color.fromARGB(255, 17, 0, 255)
                    : Colors.grey, // Cambia el color cuando es presionado
              ),
              color: isChecked
                  ? const Color.fromARGB(255, 17, 0, 255)
                  : Colors.transparent,
            ),
            child: isChecked
                ? const Center(
                    child: Icon(
                      Icons.check,
                      size: 18.0,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 4), // Espaciado entre el checkbox y el texto
          Text(widget.label),
        ],
      ),
    );
  }
}
