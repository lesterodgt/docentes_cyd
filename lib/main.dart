import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/pages/reporte_alumnos_page.dart';
import 'src/pages/reporte_envio_page.dart';
import 'src/pages/reporte_grados_page.dart';
import 'src/pages/home_page.dart';
import 'src/pages/login_page.dart';
import 'src/provider/alumnos_provider.dart';
import 'src/provider/catalogo_reportes_provider.dart';
import 'src/provider/cursos_provider.dart';
import 'src/provider/grados_provider.dart';
import 'src/provider/login_provider.dart';
import 'src/utils/preferencias_usuario.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();

  final datosAlumno = PreferenciasUsuario();
  await datosAlumno.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String rutaInicial = "login";
    final datosUsuario = PreferenciasUsuario().datosUsuario();
    if (datosUsuario.usuario != '') {
      rutaInicial = 'home';
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => GradosProvider()),
        ChangeNotifierProvider(create: (_) => AlumnosProvider()),
        ChangeNotifierProvider(create: (_) => CursosProvider()),
        ChangeNotifierProvider(create: (_) => CatalogoReportesProvider()),
      ],
      child: MaterialApp(
        initialRoute: rutaInicial,
        title: 'Docentes CYD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Docentes CYD')),
          body: Builder(
            builder: (BuildContext context) {
              return Container();
            },
          ),
        ),
        routes: {
          'login': (BuildContext context) => const LoginPage(),
          'home': (BuildContext context) => const HomePage(),
          'reporte': (BuildContext context) => const ReporteGradosPage(),
          'reporte_alumnos': (BuildContext context) => const ReporteAlumnosPage(),
          'reporte_envio': (BuildContext context) => const ReporteEnvioPage(),
          }
      ),
    );
  }
}

