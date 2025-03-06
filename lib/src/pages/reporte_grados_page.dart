import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../provider/alumnos_provider.dart';
import '../provider/grados_provider.dart';

class ReporteGradosPage extends StatefulWidget {
  const ReporteGradosPage({super.key});

  @override
  State<ReporteGradosPage> createState() => _ReporteGradosPageState();
}

class _ReporteGradosPageState extends State<ReporteGradosPage> {
  bool cargado = false;
  List<Grado> gradosDiario = [];
  List<Grado> gradosFinDeSemana = [];
  List<Grado> gradosMostrar = [];

  TextEditingController txtBuscarDiario = TextEditingController();
  String jornada = "1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grados",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          jornadaWidget(),
          buscarDiario(),
          Expanded(child: contenido(context)),
        ],
      ),
    );
  }

  Widget listaGrados(BuildContext context, List<Grado> grados) {
    return ListView.builder(
      itemCount: grados.length,
      itemBuilder: (context, index) {
        final grado = grados[index];
        return itemArchivo(context, grado);
      },
    );
  }

  Widget contenido(BuildContext context) {
    return Consumer<GradosProvider>(
      builder: (_, notifier, __) {
        if (notifier.estado == EstadoProvider.initial) {
          notifier.cargarDatos();
          return const Center(child: CircularProgressIndicator());
        } else if (notifier.estado == EstadoProvider.error) {
          return Center(
              child: Text(notifier.failure!.message,
                  style: const TextStyle(color: Colors.red)));
        } else if (notifier.estado == EstadoProvider.loaded) {
          if (!cargado) {
            gradosDiario = notifier.gradosDiario;
            gradosFinDeSemana = notifier.gradosFinDeSemana;
            gradosMostrar = gradosDiario;
            cargado = true;
          }
          return listaGrados(context, gradosMostrar);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget itemArchivo(BuildContext context, Grado grado) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () {
          final alumnosProvider =
              Provider.of<AlumnosProvider>(context, listen: false);
          alumnosProvider.cargarDatos(grado.id);
          Navigator.pushNamed(context, 'reporte_alumnos', arguments: grado);
        },
        title: Text(
          grado.nombre,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget jornadaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                jornada = "1";
                txtBuscarDiario.text = "";
                gradosMostrar = gradosDiario;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: jornada == "1" ? Colors.blue : Colors.grey,
            ),
            child: const Text("Diario",
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                jornada = "2";
                txtBuscarDiario.text = "";
                gradosMostrar = gradosFinDeSemana;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: jornada == "2" ? Colors.blue : Colors.grey,
            ),
            child: const Text("Fin de semana",
                style: TextStyle(fontSize: 17, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buscarDiario() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: txtBuscarDiario,
        onChanged: search,
        decoration: const InputDecoration(
          labelText: "Buscar",
          hintText: "Buscar",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
        ),
      ),
    );
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        gradosMostrar = jornada == "1" ? gradosDiario : gradosFinDeSemana;
      });
      return;
    }
    query = query.toLowerCase();
    List<Grado> base = jornada == "1" ? gradosDiario : gradosFinDeSemana;
    List<Grado> result = base
        .where((grado) => grado.nombre.toLowerCase().contains(query))
        .toList();
    setState(() {
      gradosMostrar = result;
    });
  }
}
