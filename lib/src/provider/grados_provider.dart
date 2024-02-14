
import '../model/estado_provider.dart';
import '../model/grado_model.dart';
import '../provider/post_provider.dart';
import 'package:flutter/material.dart';

import '../model/provider_model.dart';
import '../utils/constantes.dart';
import '../utils/preferencias_usuario.dart';

class GradosProvider extends ChangeNotifier with ProviderModel {
  final cliente = ClienteHTTP();
  List<Grado> gradosDiario = [];
  List<Grado> gradosFinDeSemana = [];

  
  }

  Future cargarDatos(String idgrado) async {
    setEstado(EstadoProvider.loading);
    const url = urlServicio;
    
    try {
      var map = <String, dynamic>{};
      map['accion'] = 'cursos';
      map['idgrado'] = idgrado;

      final decodeData = await cliente.getPost(map, url);
      if (decodeData["resultado"]) {
        gradosDiario =  Grados.fromJsonList(decodeData["registros"]).grados;
      } else {
        setFailure(Failure(4, decodeData["mensaje"]));
      }

      map['jornada'] = jornadaFinDesemana;
      final decodeData2 = await cliente.getPost(map, url);
      if (decodeData2["resultado"]) {
        gradosFinDeSemana =  Grados.fromJsonList(decodeData2["registros"]).grados;        
      } else {
        setFailure(Failure(4, decodeData2["mensaje"]));
      }

    } on Failure catch (f) {
      setFailure(f);
    }
    setEstado(EstadoProvider.loaded);
    notifyListeners();
  }
}
