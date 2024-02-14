
import '../model/alumno_model.dart';
import '../model/estado_provider.dart';
import '../provider/post_provider.dart';
import 'package:flutter/material.dart';

import '../model/provider_model.dart';
import '../utils/constantes.dart';

class AlumnosProvider extends ChangeNotifier with ProviderModel {
  final cliente = ClienteHTTP();
  
  List<Alumno> alumnosTodos = [];

  Future cargarDatos(String idgrado) async {
    setEstado(EstadoProvider.loading);
    const url = urlServicio;
    
    try {
      var map = <String, dynamic>{};
      map['accion'] = 'alumnosgrados';
      map['idgrado'] = idgrado;

      final decodeData = await cliente.getPost(map, url);

      if (decodeData["resultado"]) {
        Alumnos datos =  Alumnos.fromJsonList(decodeData["alumnos"]);
        alumnosTodos = datos.alumnosTodos;
      } else {
        setFailure(Failure(4, decodeData["mensaje"]));
      }
    } on Failure catch (f) {
      setFailure(f);
      setEstado(EstadoProvider.error);
    }
    setEstado(EstadoProvider.loaded);
    notifyListeners();
  }

}
