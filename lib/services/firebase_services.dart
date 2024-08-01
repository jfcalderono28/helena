import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

late String uid;
final firestoreInstance = FirebaseFirestore.instance;

String getUIDPaciente() {
  return uid;
}

void updateUIDPaciente(String uidNuevo) {
  uid = uidNuevo;
}

//Buscar
Future<List> getColeccion(String coleccion) async {
  CollectionReference collectionReferencePeople = db.collection(coleccion);
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final person = {
      "nombre": data["nombre"],
      "apellido": data["apellido"],
      "celular": data["celular"],
      "email": data["email"],
      "contrasenha": data["contrasenha"],
      "direccion": data["direccion"],
      "fechaNacimiento": data["fechaNacimiento"],
      "uid": documento.id
    };
    people.add(person);
  }

  return people;
} //Buscar paciente

Future<List> getPacienteDatos() async {
  CollectionReference collectionReferencePeople = db.collection("paciente");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    String uidActual = documento.id;
    if (uidActual == uid) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
      break;
    }
  }
  return people;
}

//Buscar paciente
Future<List> getPaciente(String emailPaciente) async {
  CollectionReference collectionReferencePeople = db.collection("paciente");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["email"] == emailPaciente) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
    }
  }
  return people;
}

//Buscar paciente por UID
Future<String> getDatoPacienteUID(String dato) async {
  CollectionReference collectionReferencePeople = db.collection("paciente");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  String datoFinal = "";

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    String uidActual = documento.id;

    if (uidActual == uid) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      datoFinal = person[dato];
      break;
    }
  }
  return datoFinal;
} //Buscar paciente

//Buscar Cuidador
Future<List> getCuidador(String emailCuidador) async {
  CollectionReference collectionReferencePeople = db.collection("cuidadores");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["email"] == emailCuidador) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
    }
  }
  return people;
}

//Buscar Cuidador por UID
Future<List> getCuidadorUID(String uidCuidador) async {
  CollectionReference collectionReferencePeople = db.collection("cuidadores");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (documento.id == uidCuidador) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
    }
  }
  return people;
}

Future<List> getCuidadorDatos() async {
  CollectionReference collectionReferencePeople = db.collection("cuidadores");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    String uidActual = documento.id;
    if (uidActual == uid) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
      break;
    }
  }
  return people;
}

//Buscar paciente
Future<List> getAdmin(String emailAdmin) async {
  CollectionReference collectionReferencePeople = db.collection("admin");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["email"] == emailAdmin) {
      final person = {
        "nombre": data["nombre"],
        "apellido": data["apellido"],
        "celular": data["celular"],
        "email": data["email"],
        "contrasenha": data["contrasenha"],
        "direccion": data["direccion"],
        "fechaNacimiento": data["fechaNacimiento"],
        "uid": documento.id
      };
      people.add(person);
    }
  }
  return people;
}

Future<List> getAdminDatos() async {
  CollectionReference collectionReferencePeople = db.collection("admin");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    String uidActual = documento.id;
    if (uidActual == uid) {
      final String? usuario = data["usuario"] as String?;
      final String? email = data["email"] as String?;

      if (usuario != null && email != null) {
        final person = {
          "usuario": usuario,
          "email": email,
          "uid": documento.id
        };

        people.add(person);
        break;
      }
    }
  }

  return people;
}

//Buscar

//guardar
Future<void> registrarPaciente(
  String nombre,
  String apellido,
  String contrasenha,
  int celular,
  String email,
  String direccion,
  DateTime fechaNacimiento,
) async {
  await db.collection("paciente").add({
    "nombre": nombre,
    "apellido": apellido,
    "celular": celular,
    "email": email,
    "direccion": direccion,
    "fechaNacimiento": fechaNacimiento,
    "contrasenha": contrasenha
  });
}

//guardar
Future<void> registrarCuidador(
  String nombre,
  String apellido,
  String contrasenha,
  int celular,
  String email,
  String direccion,
  DateTime fechaNacimiento,
) async {
  await db.collection("cuidadores").add({
    "nombre": nombre,
    "apellido": apellido,
    "celular": celular,
    "email": email,
    "direccion": direccion,
    "fechaNacimiento": fechaNacimiento,
    "contrasenha": contrasenha
  });
}

Future<void> actualizarPaciente(
  String uid, // Agregar uid para identificar al paciente
  String nombre,
  String apellido,
  String contrasenha,
  int celular,
  String email,
  String direccion,
  DateTime fechaNacimiento,
) async {
  // Intentar obtener el documento del paciente con el uid proporcionado
  DocumentReference pacienteRef = db.collection("paciente").doc(uid);

  // Verificar si el documento ya existe
  DocumentSnapshot pacienteDoc = await pacienteRef.get();

  if (pacienteDoc.exists) {
    // Si el documento existe, actualizar los datos del paciente
    await pacienteRef.update({
      "nombre": nombre,
      "apellido": apellido,
      "celular": celular,
      "email": email,
      "direccion": direccion,
      "fechaNacimiento": fechaNacimiento,
      "contrasenha": contrasenha,
    });
  } else {
    // Si el documento no existe, crear uno nuevo
    await pacienteRef.set({
      "nombre": nombre,
      "apellido": apellido,
      "celular": celular,
      "email": email,
      "direccion": direccion,
      "fechaNacimiento": fechaNacimiento,
      "contrasenha": contrasenha,
    });
  }
}

Future<void> actualizarCuidador(
  String uid, // Agregar uid para identificar al paciente
  String nombre,
  String apellido,
  String contrasenha,
  int celular,
  String email,
  String direccion,
  DateTime fechaNacimiento,
) async {
  // Intentar obtener el documento del cuidador con el uid proporcionado
  DocumentReference pacienteRef = db.collection("cuidadores").doc(uid);

  // Verificar si el documento ya existe
  DocumentSnapshot pacienteDoc = await pacienteRef.get();

  if (pacienteDoc.exists) {
    // Si el documento existe, actualizar los datos del cuidador
    await pacienteRef.update({
      "nombre": nombre,
      "apellido": apellido,
      "celular": celular,
      "email": email,
      "direccion": direccion,
      "fechaNacimiento": fechaNacimiento,
      "contrasenha": contrasenha,
    });
  } else {
    // Si el documento no existe, crear uno nuevo
    await pacienteRef.set({
      "nombre": nombre,
      "apellido": apellido,
      "celular": celular,
      "email": email,
      "direccion": direccion,
      "fechaNacimiento": fechaNacimiento,
      "contrasenha": contrasenha,
    });
  }
}

Future<List<Map<String, dynamic>>> getGrupo() async {
  QuerySnapshot pacienteQuery =
      await db.collection("grupos").where("uidPaciente", isEqualTo: uid).get();

  if (pacienteQuery.docs.isNotEmpty) {
    DocumentSnapshot doc = pacienteQuery.docs.first;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Si el paciente ya tiene cuidadores
    if (data.containsKey("uidCuidador") && data["uidCuidador"] != null) {
      List<String> cuidadorUids = List<String>.from(data["uidCuidador"]);

      List<Map<String, dynamic>> cuidadorDataList = [];

      for (String cuidadorUid in cuidadorUids) {
        List cuidadorData = await getCuidadorUID(cuidadorUid);

        if (cuidadorData.isNotEmpty) {
          cuidadorDataList.add(cuidadorData.first);
        }
      }

      return cuidadorDataList;
    }
  }

  // Devuelve una lista vacía si no hay datos
  return [];
}

Future<void> eliminarDelGrupo(String uidCuidador) async {
  QuerySnapshot pacienteQuery = await db
      .collection("grupos")
      .where("uidCuidador", arrayContains: uidCuidador)
      .get();

  if (pacienteQuery.docs.isNotEmpty) {
    DocumentSnapshot doc = pacienteQuery.docs.first;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Verifica si el campo "uidCuidador" es una lista
    if (data.containsKey("uidCuidador") && data["uidCuidador"] is List) {
      List<dynamic> cuidadores = List<dynamic>.from(data["uidCuidador"]);

      // Elimina al cuidador de la lista
      cuidadores.remove(uidCuidador);

      // Actualiza el documento en la base de datos con la nueva lista de cuidadores
      await doc.reference.update({
        "uidCuidador": cuidadores,
      });
    }
  }
}

Future<void> registrarCuidadorEnGrupo(String uidCuidador) async {
  // Obtener el primer documento donde el uidPaciente coincide con el uid actual
  QuerySnapshot pacienteQuery =
      await db.collection("grupos").where("uidPaciente", isEqualTo: uid).get();

  if (pacienteQuery.docs.isNotEmpty) {
    DocumentSnapshot doc = pacienteQuery.docs.first;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Si el paciente ya tiene cuidadores
    if (data.containsKey("uidCuidador") && data["uidCuidador"] != null) {
      final uidCuidadorField = data["uidCuidador"];

      if (uidCuidadorField is List) {
        List<String> cuidadores = List<String>.from(uidCuidadorField);

        // Validar si el cuidador ya está registrado
        if (!cuidadores.contains(uidCuidador)) {
          cuidadores.add(uidCuidador);

          await doc.reference.update({
            "uidCuidador": cuidadores,
          });
        } else {
          print(
              'El uidCuidador $uidCuidador ya está registrado para este paciente.');
        }
      } else {
        print(
            'El campo uidCuidador no es una lista: ${uidCuidadorField.runtimeType}');
      }
    } else {
      // Si el paciente no tiene cuidadores
      await doc.reference.update({
        "uidCuidador": [uidCuidador],
      });
    }
  } else {
    // Si el paciente no está registrado, crear uno nuevo
    await db.collection("grupos").add({
      "uidPaciente": uid,
      "uidCuidador": [uidCuidador],
    });
  }
}

//validar inicio de sesión pacientes
Future<bool> validarInicioSesionPacientes(
    String email, String contrasenha) async {
  List<dynamic> people = [];
  people = await getPaciente(email);
  bool validacion = false;
  for (var element in people) {
    String emailDB = element["email"];
    String contrasenhaDB = element["contrasenha"];

    if (emailDB == email && contrasenhaDB == contrasenha) {
      validacion = true;
      uid = element["uid"];
      break;
    }
  }

  return validacion;
}

//validar inicio de sesión Cuidadores
Future<bool> validarInicioSesionCuidadores(
    String email, String contrasenha) async {
  List<dynamic> people = [];
  people = await getCuidador(email);
  bool validacion = false;
  for (var element in people) {
    String emailDB = element["email"];
    String contrasenhaDB = element["contrasenha"];
    if (emailDB == email && contrasenhaDB == contrasenha) {
      validacion = true;
      uid = element["uid"];

      print(uid);
    }
  }

  return validacion;
}

//validar inicio de sesión pacientes
Future<bool> validarInicioSesionAdmin(String email, String contrasenha) async {
  List<dynamic> people = [];
  people = await getAdmin(email);
  bool validacion = false;
  for (var element in people) {
    String emailDB = element["email"];
    String contrasenhaDB = element["contrasenha"];

    if (emailDB == email && contrasenhaDB == contrasenha) {
      validacion = true;
      uid = element["uid"];
      break;
    }
  }

  return validacion;
}

//Buscar Cuidador
Future<List> getMedicamento(String nombreMedicamento) async {
  CollectionReference collectionReferencePeople = db.collection("medicina");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List people = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["nombre"] == nombreMedicamento) {
      final person = {
        "nombre": data["nombre"],
        "descripcion": data["descripcion"],
        "uid": documento.id
      };
      print(person);
      people.add(person);
    }
  }
  return people;
}

Future<Map<String, dynamic>?> getMedicamentoPorUid(
    String uidMedicamento) async {
  DocumentSnapshot documentSnapshot =
      await db.collection("medicina").doc(uidMedicamento).get();

  if (documentSnapshot.exists) {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

    final medicamento = {
      "nombre": data["nombre"],
      "descripcion": data["descripcion"],
      "uid": documentSnapshot.id
    };
    return medicamento;
  } else {
    return null; // Retorna null si no se encuentra el medicamento
  }
}

Future<bool> validarMedicamentoExistente(String nombre) async {
  QuerySnapshot querySnapshot = await db
      .collection("medicamentos")
      .where("nombre", isEqualTo: nombre)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<void> registrarMedicamento(
  String nombre,
  String descripcion,
) async {
  nombre = nombre.toLowerCase();
  descripcion = descripcion.toLowerCase();

  bool existe = await validarMedicamentoExistente(nombre);

  if (!existe) {
    await db.collection("medicamentos").add({
      "nombre": nombre,
      "descripcion": descripcion,
    });
    // Puedes mostrar un mensaje de éxito aquí si lo deseas
  } else {
    // Puedes mostrar un mensaje de error indicando que el medicamento ya existe
  }
}

Future<void> actualizarMedicamento(
  String nombre,
  String descripcion,
) async {
  nombre = nombre.toLowerCase();
  descripcion = descripcion.toLowerCase();

  bool existe = await validarMedicamentoExistente(nombre);

  if (!existe) {
    // Agregar nuevo medicamento
    await db.collection("medicamentos").add({
      "nombre": nombre,
      "descripcion": descripcion,
    });
    // Puedes mostrar un mensaje de éxito aquí si lo deseas
  } else {
    // Actualizar medicamento existente
    QuerySnapshot querySnapshot = await db
        .collection("medicamentos")
        .where("nombre", isEqualTo: nombre)
        .get();

    String? docId = querySnapshot.docs.first.id;
    if (docId != null) {
      await db.collection("medicamentos").doc(docId).update({
        "descripcion": descripcion,
      });
    }
    // Puedes mostrar un mensaje de éxito aquí si lo deseas
  }
}

Future<bool> validarAlergiaExistente(String nombre) async {
  QuerySnapshot querySnapshot = await db
      .collection("alergiasMedicas")
      .where("nombre", isEqualTo: nombre)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<void> registrarAlergia(
  String nombre,
  String descripcion,
) async {
  nombre = nombre.toLowerCase();
  descripcion = descripcion.toLowerCase();

  bool existe = await validarAlergiaExistente(nombre);

  if (!existe) {
    await db.collection("alergiasMedicas").add({
      "nombre": nombre,
      "descripcion": descripcion,
    });
    // Puedes mostrar un mensaje de éxito aquí si lo deseas
  } else {
    // Puedes mostrar un mensaje de error indicando que el medicamento ya existe
  }
}

Future<void> actualizarAlergia(String nombre, String descripcion) async {
  nombre = nombre.toLowerCase();
  descripcion = descripcion.toLowerCase();

  QuerySnapshot querySnapshot = await db
      .collection("alergiasMedicas")
      .where("nombre", isEqualTo: nombre)
      .get();

  String? docId = querySnapshot.docs.first.id;
  if (docId != null) {
    await db.collection("alergiasMedicas").doc(docId).update({
      "descripcion": descripcion,
    });
  }
}

Future<bool> validarAlergiaAlimenticiaExistente(String nombre) async {
  QuerySnapshot querySnapshot = await db
      .collection("alergiasAlimenticias")
      .where("nombre", isEqualTo: nombre)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<void> registrarAlergiaAlimenticia(
  String nombre,
  String descripcion,
) async {
  nombre = nombre.toLowerCase();
  descripcion = descripcion.toLowerCase();

  bool existe = await validarAlergiaAlimenticiaExistente(nombre);

  if (!existe) {
    await db.collection("alergiasAlimenticias").add({
      "nombre": nombre,
      "descripcion": descripcion,
    });
    // Puedes mostrar un mensaje de éxito aquí si lo deseas
  } else {
    // Puedes mostrar un mensaje de error indicando que el medicamento ya existe
  }
}

//Borrar
Future<void> deletePeople(String uid, String coleccion) async {
  await db.collection(coleccion).doc(uid).delete();
}

//
//
//
Future<void> deleteCuidadoresGroup(String uidTEC) async {
  CollectionReference collectionReferenceGrupos = db.collection("cuidadores");

  // Verificar si el usuario ya está registrado como cuidador en algún grupo
  QuerySnapshot cuidadorQuery = await collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uidTEC)
      .get();

  // Si no está registrado como cuidador, imprimir un mensaje y salir del método
  if (cuidadorQuery.docs.isEmpty) {
    print("El usuario no está registrado como cuidador en ningún grupo.");
    return;
  }

  // Obtener el primer grupo donde el usuario es cuidador
  DocumentSnapshot grupoDoc = cuidadorQuery.docs.first;
  Map<String, dynamic> grupoData = grupoDoc.data() as Map<String, dynamic>;

  // Obtener la lista de medicamentos existentes en el grupo
  List<Map<String, dynamic>> citasDataList = grupoData.containsKey("citas")
      ? List<Map<String, dynamic>>.from(grupoData["citas"])
      : [];

  // Agregar uidCuidador a cada medicamento

  // Actualizar el documento con la nueva lista de medicamentos
  await collectionReferenceGrupos.doc(grupoDoc.id).update({
    "citas": citasDataList,
  });
}

//
Future<void> deleteMedicamentoPorNombre(String nombreMedicamento) async {
  QuerySnapshot querySnapshot = await db
      .collection("medicamentos")
      .where("nombre", isEqualTo: nombreMedicamento)
      .get();

  String? docId = querySnapshot.docs.first.id;
  if (docId != null) {
    await db.collection("medicamentos").doc(docId).delete();
  }
}

//
Future<void> deleteAlergiaPorNombre(String nombreAlergia) async {
  QuerySnapshot querySnapshot = await db
      .collection("alergiasMedicas")
      .where("nombre", isEqualTo: nombreAlergia)
      .get();

  String? docId = querySnapshot.docs.first.id;
  if (docId != null) {
    await db.collection("alergiasMedicas").doc(docId).delete();
  }
}

Stream<List<Map<String, dynamic>>> getGrupoMedicamentosStream() {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("medicamentos") && data["medicamentos"] != null) {
        List<dynamic> medicamentosList = data["medicamentos"];

        // Ordenar los medicamentos por fecha
        medicamentosList.sort((a, b) {
          Timestamp horaA = a["hora"] as Timestamp;
          Timestamp horaB = b["hora"] as Timestamp;

          // Comparar por fecha primero
          int comparacionFecha = horaA.toDate().compareTo(horaB.toDate());
          if (comparacionFecha != 0) {
            return comparacionFecha;
          }

          // Si las fechas son iguales, comparar por hora y minutos
          int comparacionHora =
              horaA.toDate().hour.compareTo(horaB.toDate().hour);
          if (comparacionHora != 0) {
            return comparacionHora;
          }

          // Si las horas son iguales, comparar por minutos
          return horaA.toDate().minute.compareTo(horaB.toDate().minute);
        });
        // Convertir a Timestamp

        List<Map<String, dynamic>> medicamentosDataList = [];

        // Obtener la fecha y hora actual
        Timestamp now = Timestamp.now();

        // Iterar sobre los medicamentos
        for (var medicamento in medicamentosList) {
          if (medicamento is Map<String, dynamic>) {
            // Verificar si el medicamento tiene el uidCuidador correcto

            // Obtener la fecha y hora del medicamento
            Timestamp medicamentoDate = medicamento["hora"] as Timestamp;

            // Verificar si la fecha del medicamento es posterior a la fecha y hora actual
            if (medicamentoDate.compareTo(now) > 0) {
              medicamentosDataList.add(medicamento);
              // Si encuentra el primer medicamento después de la fecha y hora actual, termina el bucle
              break;
            }
          }
        }

        list.addAll(medicamentosDataList);
      }

      return list;
    });
  });
}

Stream<List<Map<String, dynamic>>> getGrupoMedicamentosSinCaducarStream() {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("medicamentos") && data["medicamentos"] != null) {
        List<dynamic> medicamentosList = data["medicamentos"];

        // Convertir a Timestamp
        Timestamp now = Timestamp.now();

        // Filtrar los medicamentos cuya fecha sea posterior a la fecha actual
        List<Map<String, dynamic>> medicamentosDataList = medicamentosList
            .where((medicamento) {
              if (medicamento is Map<String, dynamic>) {
                // Verificar si el medicamento tiene el uidCuidador correcto

                // Obtener la fecha y hora del medicamento
                Timestamp medicamentoDate = medicamento["hora"] as Timestamp;

                // Verificar si la fecha del medicamento es posterior a la fecha y hora actual
                return medicamentoDate.compareTo(now) > 0;
              }
              return false;
            })
            .map((dynamic medicamento) => medicamento as Map<String, dynamic>)
            .toList(); // Conversión de tipo

        list.addAll(medicamentosDataList);
      }

      return list;
    });
  });
}

Stream<List<Map<String, dynamic>>> getGrupoCompromisosSinCaducarStream() {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("citas") && data["citas"] != null) {
        List<dynamic> citasList = data["citas"];

        // Convertir a Timestamp
        Timestamp now = Timestamp.now();

        // Filtrar los medicamentos cuya fecha sea posterior a la fecha actual
        List<Map<String, dynamic>> citasDataList = citasList
            .where((cita) {
              if (cita is Map<String, dynamic>) {
                // Verificar si el medicamento tiene el uidCuidador correcto

                // Obtener la fecha y hora del medicamento
                Timestamp citaDate = cita["hora"] as Timestamp;

                // Verificar si la fecha del medicamento es posterior a la fecha y hora actual
                return citaDate.compareTo(now) > 0;
              }
              return false;
            })
            .map((dynamic cita) => cita as Map<String, dynamic>)
            .toList(); // Conversión de tipo

        list.addAll(citasDataList);
      }

      return list;
    });
  });
}

Stream<List<Map<String, dynamic>>> getGrupoAlimentacionStream() {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("alimentacion") && data["alimentacion"] != null) {
        List<dynamic> alimentacionList = data["alimentacion"];

        // Ordenar la alimentación por fecha
        alimentacionList.sort((a, b) {
          Timestamp horaA = a["hora"] as Timestamp;
          Timestamp horaB = b["hora"] as Timestamp;
          DateTime now = DateTime.now();

          // Comparar las fechas
          int comparacionFechaA = horaA.toDate().compareTo(now);
          int comparacionFechaB = horaB.toDate().compareTo(now);

          // Si la fecha del registro A es mayor que la actual, colocar A al final
          if (comparacionFechaA > 0) {
            return 1;
          }
          // Si la fecha del registro B es mayor que la actual, colocar B al final
          else if (comparacionFechaB > 0) {
            return -1;
          } else {
            // Si las fechas son iguales, ordenar en orden cronológico inverso
            return horaB.toDate().compareTo(horaA.toDate());
          }
        });

        List<Map<String, dynamic>> alimentacionDataList = [];

        for (var alimento in alimentacionList) {
          if (alimento is Map<String, dynamic>) {
            // Añadir la validación del uidCuidador aquí

            alimentacionDataList.add(alimento);
          }
        }

        list.addAll(alimentacionDataList);
      }

      return list;
    });
  });
}

Stream<List<Map<String, dynamic>>> getGrupoCitasStream() {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("citas") && data["citas"] != null) {
        List<dynamic> citasList = data["citas"];

        // Obtener la fecha y hora actual
        DateTime now = DateTime.now();

        // Filtrar y ordenar las citas
        List<Map<String, dynamic>> citasDataList = citasList
            .where((cita) => cita is Map<String, dynamic>)
            .map((cita) => cita as Map<String, dynamic>)
            .where((cita) => (cita["hora"] as Timestamp).toDate().isAfter(now))
            .toList();

        citasDataList.sort((a, b) {
          Timestamp horaA = a["hora"] as Timestamp;
          Timestamp horaB = b["hora"] as Timestamp;

          // Comparar por fecha completa
          int comparacionFecha = horaA.toDate().compareTo(horaB.toDate());
          if (comparacionFecha != 0) {
            return comparacionFecha;
          }

          // Si las fechas son iguales, comparar por hora, minutos y segundos
          return horaA.compareTo(horaB);
        });

        list.addAll(citasDataList);
      }

      return list;
    });
  });
}

Future<void> agregarMedicamentoAGrupo(
    List<Map<String, dynamic>> medicamentos) async {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  // Verificar si el usuario ya está registrado como cuidador en algún grupo
  QuerySnapshot cuidadorQuery = await collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .get();

  // Si no está registrado como cuidador, imprimir un mensaje y salir del método
  if (cuidadorQuery.docs.isEmpty) {
    print("El usuario no está registrado como cuidador en ningún grupo.");
    return;
  }

  // Obtener el primer grupo donde el usuario es cuidador
  DocumentSnapshot grupoDoc = cuidadorQuery.docs.first;
  Map<String, dynamic> grupoData = grupoDoc.data() as Map<String, dynamic>;

  // Obtener la lista de medicamentos existentes en el grupo
  List<Map<String, dynamic>> medicamentosDataList =
      grupoData.containsKey("medicamentos")
          ? List<Map<String, dynamic>>.from(grupoData["medicamentos"])
          : [];

  // Agregar uidCuidador a cada medicamento
  for (var medicamento in medicamentos) {
    medicamento["uidCuidador"] = uid;
  }

  // Agregar los nuevos medicamentos a la lista existente
  medicamentosDataList.addAll(medicamentos);

  // Actualizar el documento con la nueva lista de medicamentos
  await collectionReferenceGrupos.doc(grupoDoc.id).update({
    "medicamentos": medicamentosDataList,
  });
}

Future<List<String>> getMedicamentosBD() async {
  CollectionReference collectionReferencePeople = db.collection("medicamentos");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List<String> nombresMedicamentos = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final nombre = data["nombre"] as String;
    nombresMedicamentos.add(nombre);
  }

  return nombresMedicamentos;
}

Future<List<String>> getEspecialidadBD() async {
  CollectionReference collectionReferencePeople = db.collection("especialidad");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List<String> nombresEspecialidades = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final nombre = data["nombre"] as String;
    nombresEspecialidades.add(nombre);
  }

  return nombresEspecialidades;
}

Future<void> agregarAlimentoGrupo(List<Map<String, dynamic>> alimentos) async {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  // Verificar si el usuario ya está registrado como cuidador en algún grupo
  QuerySnapshot cuidadorQuery = await collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .get();

  // Si no está registrado como cuidador, imprimir un mensaje y salir del método
  if (cuidadorQuery.docs.isEmpty) {
    print("El usuario no está registrado como cuidador en ningún grupo.");
    return;
  }

  // Obtener el primer grupo donde el usuario es cuidador
  DocumentSnapshot grupoDoc = cuidadorQuery.docs.first;
  Map<String, dynamic> grupoData = grupoDoc.data() as Map<String, dynamic>;

  // Obtener la lista de medicamentos existentes en el grupo
  List<Map<String, dynamic>> alimentacionDataList =
      grupoData.containsKey("alimentacion")
          ? List<Map<String, dynamic>>.from(grupoData["alimentacion"])
          : [];

  // Agregar uidCuidador a cada medicamento
  for (var alimento in alimentos) {
    alimento["uidCuidador"] = uid;
  }

  // Agregar los nuevos medicamentos a la lista existente
  alimentacionDataList.addAll(alimentos);

  // Actualizar el documento con la nueva lista de medicamentos
  await collectionReferenceGrupos.doc(grupoDoc.id).update({
    "alimentacion": alimentacionDataList,
  });
}

Future<void> agregarCitaGrupo(List<Map<String, dynamic>> citas) async {
  CollectionReference collectionReferenceGrupos = db.collection("grupos");

  // Verificar si el usuario ya está registrado como cuidador en algún grupo
  QuerySnapshot cuidadorQuery = await collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .get();

  // Si no está registrado como cuidador, imprimir un mensaje y salir del método
  if (cuidadorQuery.docs.isEmpty) {
    print("El usuario no está registrado como cuidador en ningún grupo.");
    return;
  }

  // Obtener el primer grupo donde el usuario es cuidador
  DocumentSnapshot grupoDoc = cuidadorQuery.docs.first;
  Map<String, dynamic> grupoData = grupoDoc.data() as Map<String, dynamic>;

  // Obtener la lista de medicamentos existentes en el grupo
  List<Map<String, dynamic>> citasDataList = grupoData.containsKey("citas")
      ? List<Map<String, dynamic>>.from(grupoData["citas"])
      : [];

  // Agregar uidCuidador a cada medicamento
  for (var cita in citas) {
    cita["uidCuidador"] = uid;
  }

  // Agregar los nuevos medicamentos a la lista existente
  citasDataList.addAll(citas);

  // Actualizar el documento con la nueva lista de medicamentos
  await collectionReferenceGrupos.doc(grupoDoc.id).update({
    "citas": citasDataList,
  });
}

Future<List> getInfoMedicamentos(String nombreMedicamento) async {
  CollectionReference collectionReferencePeople = db.collection("medicamentos");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List medicamento = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["nombre"] == nombreMedicamento) {
      final person = {
        "nombre": data["nombre"],
        "descripcion": data["descripcion"],
      };
      medicamento.add(person);
    }
  }
  return medicamento;
}

Future<List> getInfocompromisos(String nombreEspecialidad) async {
  CollectionReference collectionReferencePeople = db.collection("especialidad");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  List especialidad = [];

  for (var documento in queryPeople.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    if (data["nombre"] == nombreEspecialidad) {
      final person = {
        "nombre": data["nombre"],
        "descripcion": data["descripcion"],
      };
      especialidad.add(person);
    }
  }
  return especialidad;
}

// Simula la función de obtener el stream desde Firestore

Stream<List<Map<String, dynamic>>> getGrupoAlimentacionInfoStream() {
  CollectionReference collectionReferenceGrupos =
      FirebaseFirestore.instance.collection("grupos");
  // Simulación del uid del cuidador

  return collectionReferenceGrupos
      .where("uidCuidador", arrayContains: uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.fold<List<Map<String, dynamic>>>([], (list, doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("alimentacion") && data["alimentacion"] != null) {
        List<dynamic> alimentacionList = data["alimentacion"];

        // Obtener la fecha actual
        DateTime now = DateTime.now();
        int currentDay = now.day;
        int currentMonth = now.month;
        int currentYear = now.year;

        // Filtrar los documentos según la fecha actual
        List<Map<String, dynamic>> filteredAlimentacionList = alimentacionList
            .where((alimento) {
              if (alimento is Map<String, dynamic>) {
                // Añadir la validación del uidCuidador aquí

                // Obtener la fecha del alimento
                Timestamp hora = alimento["hora"] as Timestamp;
                DateTime alimentacionDate = hora.toDate();

                // Comparar día, mes y año
                return alimentacionDate.day == currentDay &&
                    alimentacionDate.month == currentMonth &&
                    alimentacionDate.year == currentYear;
              }
              return false;
            })
            .cast<Map<String, dynamic>>()
            .toList();

        // Ordenar la lista filtrada por fecha
        filteredAlimentacionList.sort((a, b) {
          Timestamp horaA = a["hora"] as Timestamp;
          Timestamp horaB = b["hora"] as Timestamp;

          // Comparar las fechas
          return horaB.toDate().compareTo(horaA.toDate());
        });

        list.addAll(filteredAlimentacionList);
      }

      return list;
    });
  });
}
