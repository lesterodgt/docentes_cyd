
import '../model/curso_model.dart';
import '../model/estado_provider.dart';
import '../model/periodo_model.dart';
import '../provider/post_provider.dart';
import 'package:flutter/material.dart';

import '../model/provider_model.dart';
import '../utils/constantes.dart';
class CursosProvider extends ChangeNotifier with ProviderModel {
  final cliente = ClienteHTTP();
  List<Periodo> periodos = [];
  List<Curso> cursos = [];

  
  limpiar() {
    setEstado(EstadoProvider.initial);
    periodos = [];
    cursos = [];
  }

  Future cargarDatos(String idgrado) async {
    setEstado(EstadoProvider.loading);
    
    try {
      var map = <String, dynamic>{};
      map['accion'] = 'cursos';
      map['idgrado'] = idgrado;

      final decodeData = await cliente.getPost(map, urlServicio);
      if (decodeData["resultado"]) {
        periodos =  Periodos.fromJsonList(decodeData["periodos"]).periodos;
        cursos =  Cursos.fromJsonList(decodeData["cursos"]).cursos;
      } else {
        setFailure(Failure(4, decodeData["mensaje"]));
      }
    } on Failure catch (f) {
      setFailure(f);
    }
    setEstado(EstadoProvider.loaded);
    notifyListeners();
  }
}
