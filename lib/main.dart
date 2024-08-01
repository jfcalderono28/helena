import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helena/administrador/alimentacion/alergiaAlimentoNueva.dart';
import 'package:helena/administrador/configA.dart';
import 'package:helena/administrador/medicina/alergiaMedicaNueva.dart';
import 'package:helena/administrador/medicina/medicamentoNuevo.dart';
import 'package:helena/administrador/medicina/medicina.dart';
import 'package:helena/administrador/usuarios.dart';
import 'package:helena/iniciarSesion/iniciarSesionAdmin.dart';
import 'package:helena/iniciarSesion/iniciarSesionCuidador.dart';
import 'package:helena/iniciarSesion/iniciarSesionPaciente.dart';
import 'package:helena/login/paginaInicial.dart';
import 'package:helena/login/registro.dart';
import 'package:helena/login/registroCuidador.dart';
import 'package:helena/login/registroPaciente.dart';
import 'package:helena/paginasCuidador/add_page.dart';
import 'package:helena/paginasCuidador/buscar_page.dart';
import 'package:helena/paginasCuidador/calendar_page.dart';
import 'package:helena/paginasCuidador/config.dart';
import 'package:helena/paginasCuidador/food_page.dart';
import 'package:helena/paginasCuidador/pills_page.dart';
import 'package:helena/paginasPaciente/anhadirCuidador.dart';
import 'package:helena/administrador/paginaInicialAdmin.dart';
import 'package:helena/paginasCuidador/paginaInicialCuidador.dart';
import 'package:helena/paginasPaciente/configP.dart';
import 'package:helena/paginasPaciente/paginaInicialPaciente.dart';
import 'package:helena/iniciarSesion/iniciarSesion.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => const Inicial(),
        "iniciarSesion": (BuildContext context) => const InicioSesion(),
        "registro": (BuildContext context) => const Registro(),
        // Paciente
        "iniciarSesionPaciente": (BuildContext context) =>
            const IniciarSesionPaciente(),
        "inicioPaciente": (BuildContext context) =>
            const PaginaInicioPaciente(),
        "registroPaciente": (BuildContext context) => const RegistroPaciente(),
        "addCuidador": (BuildContext context) => const addCuidador(),
        'configP': (context) => const ConfigP(),
        // Cuidador
        "registroCuidador": (BuildContext context) => const Registrocuidador(),
        "iniciarSesionCuidador": (BuildContext context) =>
            const IniciarSesionCuidador(),
        "inicioCuidador": (BuildContext context) =>
            const PaginaInicioCuidador(),
        // Admin
        "iniciarsesionadmi": (BuildContext context) =>
            const IniciarAdministrador(),
        'configA': (context) => const ConfigA(),
        "PaginaInicioAdmin": (BuildContext context) =>
            const PaginaInicioAdmin(),
        "Usuarios": (BuildContext context) => const Usuarios(),
        "Medicina": (BuildContext context) => const Medicina(),
        "medicamentoNuevo": (BuildContext context) => const MedicamentoNuevo(),
        "alergiaMedicaNueva": (BuildContext context) =>
            const AlergiaMedicaNueva(),
        "alergiaAlimentoNueva": (BuildContext context) =>
            const AlergiaAlimentoNueva(),
        // Rutas adicionales del segundo archivo
        '/add': (context) => const AddPage(),
        '/pills': (context) => const Pills(),
        '/calendario': (context) => const Calendar(),
        '/alimentos': (context) => const Food(),
        '/buscar': (context) => const Buscar(),
        '/config': (context) => const Config(),
      },
    );
  }
}
