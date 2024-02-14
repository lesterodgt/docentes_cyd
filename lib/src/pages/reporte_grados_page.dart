import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/grado_model.dart';
import '../provider/grados_provider.dart';
import '../utils/constantes.dart';


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
    if (!cargado) {
      GradosProvider gradosProvider = Provider.of<GradosProvider>(context);
      gradosDiario = gradosProvider.gradosDiario;
      gradosFinDeSemana = gradosProvider.gradosFinDeSemana;
      gradosMostrar = gradosDiario;

      cargado = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grados"),
      ),
      body: ListView(
        children: [
          jornadaWidget(),
          buscarDiario(),
          listaGrados(context, gradosMostrar),
        ],
      ),
    );
  }

  Widget listaGrados(BuildContext context, List<Grado> grados) {
    return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: grados.length,
            itemBuilder: (context, index) {
              final grado = grados.elementAt(index);
              return itemArchivo(context, grado);
            },
          
    );
  }

  Widget encabezado() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Text(
        "Asitencia por grados",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget itemArchivo(BuildContext context, Grado grado) {
    return Card(
      color: Colors.blue.shade50,
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, 'reporte_alumnos', arguments: grado),
        title: Text(
          grado.nombre,
          style: const TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }

  Widget jornadaWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          color: jornada==jornadaDiario?Colors.blue: Colors.grey,
          onPressed: () {
            if(jornada==jornadaFinDesemana){
              setState(() {
                jornada = jornadaDiario;
                txtBuscarDiario.text = "";
                gradosMostrar = jornada==jornadaDiario?gradosDiario:gradosFinDeSemana;
              });
            }
          },
          child: const Text(
            'Diario',
            style: TextStyle(fontSize: 17, color: Colors.white,),
          ),
        ),
        MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          color: jornada==jornadaFinDesemana?Colors.blue: Colors.grey,
          onPressed: () {
            if(jornada==jornadaDiario){
              setState(() {
                jornada = jornadaFinDesemana;
                txtBuscarDiario.text= "";
                gradosMostrar = jornada ==jornadaDiario?gradosDiario:gradosFinDeSemana;
              });
            }
          },
          child: const Text(
            'Fin de semana',
            style: TextStyle(fontSize: 17, color: Colors.white,),
          ),
        ),
      ],
    );
  }

  Widget buscarDiario() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: TextFormField(
        controller: txtBuscarDiario,
        onChanged: search,
        decoration: const InputDecoration(
          labelText: "Buscar",
          hintText: "Buscar",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        gradosMostrar = jornada=="1"?gradosDiario:gradosFinDeSemana;
      });
      return;
    }
    query = query.toLowerCase();
    List<Grado> base = jornada=="1"?gradosDiario:gradosFinDeSemana;
    List<Grado> result = [];
    for (var grado in base) {
      var nombre = grado.nombre.toLowerCase();
      if (nombre.contains(query)) {
        result.add(grado);
      }
    }
    setState(() {
      gradosMostrar = result;
    });
  }
}
