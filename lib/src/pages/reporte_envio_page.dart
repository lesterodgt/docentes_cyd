import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:toast/toast.dart';

import '../model/alumno_model.dart';
import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../provider/alumnos_provider.dart';
import '../provider/cursos_provider.dart';

class ReporteEnvioPage extends StatefulWidget {
  const ReporteEnvioPage({super.key});

  
  @override
  State<ReporteEnvioPage> createState() => _ReporteEnvioPageState();
}

class _ReporteEnvioPageState extends State<ReporteEnvioPage> {
  bool cargado = false;
  late Grado grado;

  @override
  Widget build(BuildContext context) {
    grado = ModalRoute.of(context)?.settings.arguments as Grado;
    if (!cargado) {
      cargado = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Reporte')),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: ListView(
              children: [
                StickyHeader(
                  header: encabezado(),
                  content: contenido(context),
                ),
                const SizedBox(height: 100)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        focusColor: Colors.indigo,
        backgroundColor: Colors.indigoAccent,
        child: const Icon(Icons.send_outlined, size: 30),
      ),
    );
  }

  Widget encabezado() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Text(
              grado.nombre,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget contenido(BuildContext context) {
    
    return Consumer<CursosProvider>(
      builder: (_, notifier, __) {
        if (notifier.estado == EstadoProvider.initial) {
          notifier.cargarDatos(grado.id);
          return const Center(child: CircularProgressIndicator());
        }else if (notifier.estado == EstadoProvider.error) {
          return Text(notifier.failure!.message);
        } 
        else if (notifier.estado == EstadoProvider.loaded) {
          return Container();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  

}
