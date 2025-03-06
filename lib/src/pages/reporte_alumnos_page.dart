import 'package:docentes_cyd/src/provider/cursos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/alumno_model.dart';
import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../provider/alumnos_provider.dart';

class ReporteAlumnosPage extends StatefulWidget {
  const ReporteAlumnosPage({Key? key}) : super(key: key);

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
        appBar: AppBar(
          title: const Text('Estudiantes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              encabezado(),
              Expanded(child: contenido(context)),
            ],
          ),
        ),
        floatingActionButton: botonEnviar(grado));
  }

  Widget botonEnviar(Grado grado) {
    final alumnosTodos =
        Provider.of<AlumnosProvider>(context, listen: false).alumnosTodos;
    bool hayMarcados = alumnosTodos.any((alumno) => alumno.marcado);
    //bool hayMarcados = true;
    return FloatingActionButton(
      onPressed: hayMarcados
          ? () {
              Provider.of<CursosProvider>(context, listen: false).limpiar();
              Navigator.pushNamed(context, 'reporte_envio', arguments: grado);
            }
          : null,
      backgroundColor: hayMarcados ? Colors.indigoAccent : Colors.grey,
      child: const Icon(Icons.send_outlined, size: 30, color: Colors.white),
    );
  }

  Widget encabezado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Center(
        child: Text(
          grado.nombre,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey),
        ),
      ),
    );
  }

  Widget contenido(BuildContext context) {
    return Consumer<AlumnosProvider>(
      builder: (_, notifier, __) {
        if (notifier.estado == EstadoProvider.initial) {
          notifier.cargarDatos(grado.id);
          return const Center(child: CircularProgressIndicator());
        } else if (notifier.estado == EstadoProvider.error) {
          return Center(
              child: Text(notifier.failure!.message,
                  style: const TextStyle(color: Colors.red)));
        } else if (notifier.estado == EstadoProvider.loaded) {
          return listaEstudiantes(context, notifier.alumnosTodos);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget listaEstudiantes(BuildContext context, List<Alumno> alumnos) {
    return Column(
      children: [
        opciones(alumnos),
        Expanded(
          child: ListView.builder(
            itemCount: alumnos.length,
            itemBuilder: (context, index) {
              final alumno = alumnos[index];
              return itemAlumno(context, alumno);
            },
          ),
        ),
      ],
    );
  }

  Widget itemAlumno(BuildContext context, Alumno alumno) {
    // Determinar colores de fondo y de texto
    Color cardColor;
    Color textColor;

    if (alumno.estado == "1") {
      cardColor = Colors.blue.shade100; // Color para alumnos con permiso
      textColor = Colors.blue.shade900;
    } else if (alumno.marcado) {
      cardColor = Colors.green.shade100; // Color para alumnos seleccionados
      textColor = Colors.green.shade900;
    } else {
      cardColor = Colors.white; // Color por defecto
      textColor = Colors.black;
    }

    // Determinar ícono
    Widget iconoFinal = alumno.estado == "1"
        ? const Icon(Icons.supervisor_account_sharp, color: Colors.blue)
        : (alumno.marcado
            ? const Icon(Icons.check_box, color: Colors.green)
            : const Icon(Icons.check_box_outline_blank, color: Colors.grey));

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: cardColor,
      child: ListTile(
        leading: iconoFinal,
        title: Text(
          alumno.nombreAlumno,
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: textColor),
        ),
        onTap: alumno.estado == "1"
            ? null // No permite tocar si el alumno tiene permiso
            : () {
                setState(() {
                  alumno.marcado = !alumno.marcado;
                });
              },
      ),
    );
  }

  Widget opciones(List<Alumno> alumnos) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var alumno in alumnos) {
                  alumno.marcado = true;
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Todos',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                for (var alumno in alumnos) {
                  alumno.marcado = false;
                }
              });
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
            child: const Text('Ninguno',
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
