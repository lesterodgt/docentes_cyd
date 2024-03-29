
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

  GradosProvider(){
    if(gradosDiario.isEmpty){
      cargarDatos();
    }
  }

  Future cargarDatos() async {
    setEstado(EstadoProvider.loading);
    
    final datosUsuario = PreferenciasUsuario().datosUsuario();
    try {
      var map = <String, dynamic>{};
      map['accion'] = 'grados';
      map['jornada'] = jornadaDiario;
      map['idUsuario'] = datosUsuario.idtipousuario=="2"? datosUsuario.idusuario: "0";

      final decodeData = await cliente.getPost(map, urlServicio);
      if (decodeData["resultado"]) {
        gradosDiario =  Grados.fromJsonList(decodeData["registros"]).grados;
      } else {
        setFailure(Failure(4, decodeData["mensaje"]));
      }

      map['jornada'] = jornadaFinDesemana;
      final decodeData2 = await cliente.getPost(map, urlServicio);
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
