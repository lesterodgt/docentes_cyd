import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:toast/toast.dart';

import '../model/alumno_model.dart';
import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../provider/alumnos_provider.dart';

class ReporteAlumnosPage extends StatefulWidget {
  const ReporteAlumnosPage({super.key});

  
  @override
  State<ReporteAlumnosPage> createState() => _ReporteAlumnosPageState();
}

class _ReporteAlumnosPageState extends State<ReporteAlumnosPage> {
  bool cargado = false;
  late Grado grado;

  @override
  Widget build(BuildContext context) {
    grado = ModalRoute.of(context)?.settings.arguments as Grado;
    if (!cargado) {
      cargado = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Estudiantes')),
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
    final alumnosProvider = Provider.of<AlumnosProvider>(context, listen: false);
    return Consumer<AlumnosProvider>(
      builder: (_, notifier, __) {
        if (notifier.estado == EstadoProvider.initial) {
          alumnosProvider.cargarDatos(grado.id);
          return const Center(child: CircularProgressIndicator());
        }else if (notifier.estado == EstadoProvider.error) {
          return Text(notifier.failure!.message);
        } 
        else if (notifier.estado == EstadoProvider.loaded) {
          return listaEstudiantes(context, notifier.alumnosTodos);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget listaEstudiantes(BuildContext context, List<Alumno> alumnos) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          opciones(alumnos),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: alumnos.length,
            itemBuilder: (context, index) {
              final alumno = alumnos.elementAt(index);
              return itemAlumno(context, alumno);
            },
          ),
        ],
      ),
    );
  }

  Widget itemAlumno(BuildContext context, Alumno alumno) {
    Widget icono = alumno.marcado
        ? const Icon(Icons.check_box, color: Colors.green)
        : const Icon(Icons.check_box_outline_blank, color: Colors.grey);
    return Card(
      child: ListTile(
        leading: icono,
        minLeadingWidth: 0,
        title: Text(
          alumno.nombreAlumno,
          style: const TextStyle(fontSize: 15.0),
        ),
        onTap: () {
          setState(() {
            alumno.marcado = !alumno.marcado;
          });
        },
      ),
    );
  }
  
  
   Widget opciones(List<Alumno> alumnos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.blue,
          onPressed: () {
            setState(() {
              for (var alumno in alumnos) {
                alumno.marcado = true;
              }
            });
          },
          child: const Text(
            'Todos',
            style: TextStyle(fontSize: 17, color: Colors.white,),
          ),
        ),
        MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.orangeAccent,
          onPressed: () {
            setState(() {
              for (var alumno in alumnos) {
                alumno.marcado = false;
              }
            });
          },
          child: const Text(
            'Ninguno',
            style: TextStyle(fontSize: 17, color: Colors.white,),
          ),
        ),
      ],
    );
  }

}
