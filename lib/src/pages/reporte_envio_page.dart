import 'package:docentes_cyd/src/provider/catalogo_reportes_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:toast/toast.dart';

import '../model/alumno_model.dart';
import '../model/curso_model.dart';
import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../model/motivo_reporte_model.dart';
import '../model/periodo_model.dart';
import '../provider/alumnos_provider.dart';
import '../provider/cursos_provider.dart';
import '../provider/reportes_provider.dart';

class ReporteEnvioPage extends StatefulWidget {
  const ReporteEnvioPage({super.key});

  
  @override
  State<ReporteEnvioPage> createState() => _ReporteEnvioPageState();
}

class _ReporteEnvioPageState extends State<ReporteEnvioPage> {
  bool cargado = false;
  late Grado grado;

  String? selectedValueCurso;
  String? selectedValuePeriodo;
  String? selectedValueMotivo;
  String? selectedValueReporte;

  final TextEditingController textCursoController = TextEditingController();
  final TextEditingController textReporteController = TextEditingController();

  late CatalogoReportesProvider motivosProvider;
  late List<TipoReporte> tiposReporte = [];

  @override
  void dispose() {
    textCursoController.dispose();
    textReporteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    grado = ModalRoute.of(context)?.settings.arguments as Grado;
    if (!cargado) {
      motivosProvider = Provider.of<CatalogoReportesProvider>(context);
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
          return datos(notifier.periodos, notifier.cursos);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget datos(List<Periodo> periodos, List<Curso> cursos) {
    return Column(
      children: [
        periodosWidget(periodos),
        const SizedBox(height: 15),
        cursosWidget(cursos),
        const SizedBox(height: 15),
        catalogoReporteWidget(),
        const SizedBox(height: 15),
        tipoReporteWidget(),
        const SizedBox(height: 15),
        btnCrearReporte()
      ],
    );
  }

  Widget cursosWidget(List<Curso> cursos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Text(
            'Elegir Curso',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          items: cursos
              .map((Curso curso) => DropdownMenuItem(
                    value: "${curso.id};;${curso.nombre.toLowerCase()}",
                    child: Text(
                      curso.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValueCurso,
          onChanged: (value) {
            setState(() {
              selectedValueCurso = value;
            });
          },
          buttonStyleData: estiloLista,
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 50,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textCursoController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(top: 8,bottom: 4,right: 8,left: 8),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textCursoController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue.toLowerCase());
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textCursoController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget periodosWidget(List<Periodo> periodos) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Text(
            'Elegir Periodo',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          items: periodos
              .map((Periodo periodo) => DropdownMenuItem(
                    value: periodo.id,
                    child: Text(
                      periodo.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValuePeriodo,
          onChanged: (value) {
            setState(() {
              selectedValuePeriodo = value;
            });
          },
          buttonStyleData: estiloLista,
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget catalogoReporteWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Text(
            'Motivo',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          items: motivosProvider.motivosReporte
              .map((GrupoReporte motivo) => DropdownMenuItem(
                    value: motivo.descripcion,
                    child: Text(
                      motivo.descripcion,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValueMotivo,
          onChanged: (value) {
            setState(() {
              selectedValueMotivo = value;
              selectedValueReporte = null;
              GrupoReporte? resultado = motivosProvider.tipoReporteMap[value];
              tiposReporte = resultado!.tipos;
            });
          },
          buttonStyleData: estiloLista,
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget tipoReporteWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: const Text(
            'Reporte',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          items: tiposReporte
              .map((TipoReporte tipo) => DropdownMenuItem(
                    value: tipo.descripcion,
                    child: Text(
                      tipo.descripcion,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValueReporte,
          onChanged: (value) {
            setState(() {
              selectedValueReporte = value;
            });
          },
          buttonStyleData: estiloLista,
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 50,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textReporteController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(top: 8,bottom: 4,right: 8,left: 8),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textReporteController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Buscar',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().contains(searchValue.toLowerCase());
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textReporteController.clear();
            }
          },
        ),
      ),
    );
  }
  
  final estiloLista = ButtonStyleData(
    padding: const EdgeInsets.symmetric(horizontal: 26),
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.black26),
      color: Colors.white,
    ),
    elevation: 2,
  );


  Widget btnCrearReporte(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.send, size: 35, color: Colors.white),
        onPressed: () async {
          final alumnosProvider = Provider.of<AlumnosProvider>(context, listen: false);
          List<Alumno> alumnosEnviar = [];
          for (var alumno in alumnosProvider.alumnosTodos) {
            if (alumno.marcado) alumnosEnviar.add(alumno);
          }
          ReportesProvider reportesProvider = Provider.of<ReportesProvider>(context, listen: false);
          bool resultado = await reportesProvider.enviarReporte( 
            alumnosEnviar,  selectedValueCurso!, 
            selectedValuePeriodo!,  textReporteController.text, 
            selectedValueMotivo!
          );
          if(resultado){
            Toast.show("Reporte ingresado correctamente",duration: Toast.lengthLong, gravity: Toast.center);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }else{
            Toast.show("No fue posible ingresar reporte",duration: Toast.lengthLong, gravity: Toast.center);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text("Crear reporte", style: TextStyle(fontSize: 20)),
        )
      ),
    ); 
  }

}
